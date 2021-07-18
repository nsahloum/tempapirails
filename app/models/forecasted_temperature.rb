class ForecastedTemperature < ApplicationRecord
	belongs_to :location
	validates :location_id, uniqueness: { scope: :date_forecasted }
end
