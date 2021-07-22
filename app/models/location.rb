class Location < ApplicationRecord
	extend FriendlyId #this gem do the work to have slug_name as id and in the url
	friendly_id :slug_name, use: :slugged
	has_many :forecasted_temperatures, dependent: :destroy
	validates_uniqueness_of :slug_name
	
	#to update the slug when slug_name changed
	def slug_name=(value)
		if value.present?
		  write_attribute(:slug, value)
		  write_attribute(:slug_name, value)
		end
	  end
end
