class ForecastedTemperaturesController < ApplicationController
	
	def index
		@forecasted_temperatures = ForecastedTemperature.all
		render json: @forecasted_temperatures
    end 

    def show
        @forecasted_temperature = ForecastedTemperature.find(params[:id])
        render json: @forecasted_temperature
    end 

	def destroy
        @forecasted_temperatures = ForecastedTemperature.all 
        @forecasted_temperature = ForecastedTemperature.find(params[:id])
        @forecasted_temperature.destroy
        render json: @forecasted_temperatures
    end 

	def create_temp(data, location)
		day_1 = []
		day_2 = []
		day_3 = []
		day_4 = []
		timezone = 0
		start = 18 + timezone
		i = 0
		while timezone != 24
			day_1 << data["dataseries"][i]["temp2m"]
			i = i + 1
			timezone = timezone + 3
		end
		ForecastedTemperature.create(date_forecasted: DateTime.parse(data["init"]).to_date, min_forecasted: day_1.min, max_forecasted: day_1.max, location_id: location.id)
		#return DateTime.parse(data[init]).to_date
	end

	def get_data(location, long, lat)
		url = "https://www.7timer.info/bin/api.pl?lon=#{long}&lat=#{lat}&product=astro&output=json"
		response = RestClient.get(url)
		response_hash = JSON.parse(response)
		create_temp(response_hash, location)
		#render json: response_hash["init"]
	end
	
	def show_location_temp
		@location = Location.friendly.find(params[:location_id])
		@long = @location.longitude
		@lat = @location.latitude
		get_data(@location, @long, @lat)
        @forecasted_temperatures = @location.forecasted_temperatures
        render json: @forecasted_temperatures
	end
end
