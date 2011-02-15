require 'open-uri'
require 'active_record'
require 'delayed_job'
require 'set'
require 'gouge/utils'
require 'nokogiri'

class Object
  def metaclass
    class << self
      self
    end
  end
end

class Gouge::DataRow < ActiveRecord::Base
  serialize :data
end

class Gouge::Scraper < ActiveRecord::Base

  include Gouge::Utils

  serialize :url_atts

  has_many :data_rows

  after_create :queue

  def queue
    Delayed::Job.enqueue self
  end
  
  def load(url)
    url = self.domain + url if self.domain
    url_to_scrape = (url) % url_atts
    puts url_to_scrape
    @html = open(url_to_scrape) {|f| f.read}
  end
  
  def first(element,value="text()")
    @doc ||= Nokogiri::HTML(@html)
    if (d = @doc.search(element))
      return d[0].search(value).to_s
    else
      return nil
    end
  end
  
  def make_hash(element,key,value)
    @doc ||= Nokogiri::HTML(@html)
    values = {}
    @doc.search(element).each do |el|
      values[el.search(key).to_s] = el.search(value).to_s
    end
    yield @doc,values if block_given?
    return values
  end
  
  def make_regexp_hash(r)
    values = {}
    if (matches = @html.scan r) 
      matches.each do |m|
        field,value = m[0],m[1]
        values[field] = value
      end
    end 
    yield @html,values if block_given?
    return values
  end
  
  def make_regexp_list(regexp,n=nil)
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
  
  def data_row(key,values)
    self.data_rows.create! :key => key, :data => values
  end
  
  def perform
    self.started = true
    self.scrape
    self.finished = true
    self.save!
  end
  
  def now_scrape(scraper,*atts)
    Object.const_get(scraper).create! :url_atts=> atts, :triggered_by => self 
  end
  
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
  
  def self.construct name,options={},&block 
    cls = Class.new(Gouge::Scraper) 
    options.each do |h,v|
      puts "DEFINING #{h} on #{cls}"
      cls.metaclass.send(:define_method,h, Proc.new {v})
    end
    cls.send(:define_method,:scrape, block)
    Object.const_set name, cls 
    self.add_scraper(cls)
    puts cls.respond_to?(:button)
  end
end