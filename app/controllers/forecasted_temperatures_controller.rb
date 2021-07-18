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
	
	def parse_days (day, all_days, first)
		while first == 0 || @start % 24 != 0
			first = 1
			@start = @start + 3
			day << all_days[@i]
			@i = @i + 1
		end
	end

	def create_temp(data, location)
		@i = 0
		all_days = []
		data["dataseries"].each do |elem|
			all_days << elem["temp2m"]
		end		
		timezone = 0
		@start = 18 + timezone + 3
		day_1 = []
		day_2 = []
		day_3 = []
		day_4 = []
		parse_days(day_1, all_days, 0)
		parse_days(day_2, all_days, 0)
		parse_days(day_3, all_days, 0)
		parse_days(day_4, all_days, 0)
		to_delete = day_1.length()
		day_4.pop(to_delete)
		#ForecastedTemperature.create(date_forecasted: DateTime.parse(data["init"]).to_date, min_forecasted: day_1.min, max_forecasted: day_1.max, location_id: location.id)
		#ForecastedTemperature.create(date_forecasted: DateTime.parse(data["init"]).to_date + 1, min_forecasted: day_2.min, max_forecasted: day_2.max, location_id: location.id)
		render json: day_4
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
        #render json: @forecasted_temperatures
	end
end
