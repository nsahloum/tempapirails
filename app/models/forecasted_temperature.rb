class ForecastedTemperature < ApplicationRecord
	belongs_to :location
	validates :location_id, uniqueness: { scope: :date_forecasted }
	scope :filter_by_date_forecasted, -> (date_forecasted) { where date_forecasted: date_forecasted }
end
