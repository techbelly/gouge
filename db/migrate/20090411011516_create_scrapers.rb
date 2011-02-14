class CreateScrapers < ActiveRecord::Migration
	def self.up
		create_table :scrapers do |t|
		  t.string :type
		  t.string :domain
		  t.string :url
		  t.string :url_atts
		  t.string :finished
		  t.integer :triggered_by
			t.timestamps
		end
		
		create_table :data_row do |t|
		  t.string :key
		  t.text   :data
		  t.string :scraper_id
		end
		
	end
end
