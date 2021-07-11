class Location < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_name, use: :slugged
end
