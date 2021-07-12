class Location < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_name, use: :slugged
	has_many :forecasted_temperatures
end
