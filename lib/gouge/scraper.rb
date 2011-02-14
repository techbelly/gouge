require 'open-uri'
require 'active_record'
require 'delayed_job'
require 'set'
require 'gouge/utils'

class Object
  def metaclass
    class << self
      self
    end
  end
end

class Gouge::Scraper < ActiveRecord::Base

  include Gouge::Utils

  after_create :queue

  def self.add_scraper(scraper)
    self.all << scraper
  end

  def self.all
    @scrapers ||= []
    @scrapers
  end

  def self.launchables
    self.all.select {|s| s.respond_to?(:button)}
  end

  def queue
    Delayed::Job.enqueue self
  end
  
  def load(url)
    url_to_scrape = (self.domain+url) % scrape_atts
    @html = open(url_to_scrape) {|f| f.read}
  end
  
  def make_hash(r)
    values = {}
    if (matches = @html.scan r) 
      matches.each do |m|
        field,value = m[0],m[1]
        values[field] = value
      end
    end 
    yield html,values if block_given?
    return values
  end
  
  def make_list(regexp,n=nil)
    ids = Set.new()
    if (matches = @html.scan regexp) 
      matches.each do |m|
        id = m[0]
        unless ids.include? id
          yield id
          ids.add(id)
          break if n && ids.length >= n
        end
      end
    end
  end
  
  def now_scrape(scraper,atts={})
    Object.const_get(scraper).create! :url_atts=> atts, :triggered_by => self 
  end
  
  def self.construct name,options={},&block 
    cls = Class.new(Gouge::Scraper) 
    options.each do |h,v|
      puts "DEFINING #{h} on #{cls}"
      cls.metaclass.send(:define_method,h, Proc.new {v})
    end
    cls.send(:define_method,:perform, block)
    Object.const_set name, cls 
    self.add_scraper(cls)
    puts cls.respond_to?(:button)
  end
end

