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

	def interval_days(data)
		timepoints = []
		data["dataseries"].each do |elem|
			timepoints << elem["timepoint"]
		end	
		@number_days = (timepoints.last / 24) + 1
		@frequency_hours = timepoints[1] - timepoints[0]
	end

	def create_temperatures(days, location, data)
		date = DateTime.parse(data["init"]).to_date
		i = 1
		@number_days.times do
			ForecastedTemperature.create(date_forecasted: date, min_forecasted: days[i].min,
			max_forecasted: days[i].max, location_id: location.id)
			date = date + 1
			i = i + 1
		end
	end

	def get_temp(data, location)
		@start = data["init"].last(2).to_i
		interval_days(data)
		all_days_temp = []
		data["dataseries"].each do |elem|
			all_days_temp << elem["temp2m"]
		end		
		timezone = Timezone.lookup(location.latitude, location.longitude).utc_offset / 3600
		@start = @start + timezone + @frequency_hours
		days = {}
		i = 1
		a = 0
		@number_days.times do
			days[i] = []
			while @start < 24
				days[i] << all_days_temp[a]
				a = a + 1
				@start = @start + @frequency_hours
			end
			@start = 0
			i = i + 1
		end
		to_delete = days[1].length()
		days[i-1].pop(to_delete)
		create_temperatures(days, location, data)
	end

	def get_data(location, long, lat)
		url = "https://www.7timer.info/bin/api.pl?lon=#{long}&lat=#{lat}&product=astro&output=json"
		response = RestClient.get(url)
		response_hash = JSON.parse(response)
		get_temp(response_hash, location)
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
