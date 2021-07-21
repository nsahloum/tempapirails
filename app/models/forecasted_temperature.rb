class ForecastedTemperature < ApplicationRecord
	belongs_to :location
	validates :location_id, uniqueness: { scope: :date_forecasted }
	scope :filter_by_date_forecasted, -> (date_forecasted) { where date_forecasted: date_forecasted }
	def as_json(*) #to have a beautiful json render
		super.except("date_forecasted", "max_forecasted", "min_forecasted").tap do |hash|
		  hash["date"] = date_forecasted
		  hash["max_forecasted"] = max_forecasted
		  hash["min_forecasted"] = min_forecasted
		end
	  end
end
