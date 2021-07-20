class ApplicationController < ActionController::API

	#This function calculate the number of day the data from 7timer concern
	#and the frequency of timepoints (when the temperature are taken)
	def interval_days(data)
		timepoints = []
		data["dataseries"].each do |elem|
			timepoints << elem["timepoint"]
		end	
		@number_days = (timepoints.last / 24) + 1
		@frequency_hours = timepoints[1] - timepoints[0]
	end

	#this function is a loop for creating the forecasted temperatures by day
	#The start date is the date when the data are initilize in 7info
	#Note : in the model of Forecasted Temperatures, there is a uniqueness condition
	#for the date and the location. So if we run a CRON job every day or even every minutes, the data for the same location and the same
	#date will not be added. The new forecasted temperaturs will only be added if the date or the location are different
	def create_temperatures(days, location, date)
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
		date = DateTime.parse(data["init"]).to_date
		create_temperatures(days, location, date)
	end

	def get_data
		if params[:location].present?
			@location = Location.friendly.find(params[:location])
			find_data(@location)
		else
			@locations = Location.all
			@locations.each do |location|
				find_data(location)
			end
		end
	end

	def find_data(location)
		@long = location.longitude
		@lat = location.latitude
		url = "https://www.7timer.info/bin/api.pl?lon=#{@long}&lat=#{@lat}&product=astro&output=json"
		response = RestClient.get(url)
		response_hash = JSON.parse(response)
		get_temp(response_hash, location)
	end
end
