class Location < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_name, use: :slugged
	has_many :forecasted_temperatures
	validates_uniqueness_of :slug_name
	scope :filter_by_slug, -> (slug) { where slug: slug }
end
