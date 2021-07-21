class ApplicationController < ActionController::API

	#The method interval_days calculate the number of day the data from 7timer concern
	#and the frequency of timepoints (when the temperature are taken)
	def interval_days(data)
		timepoints = []
		data["dataseries"].each do |elem|
			timepoints << elem["timepoint"]
		end	
		@number_days = (timepoints.last / 24) + 1
		@frequency_hours = timepoints[1] - timepoints[0]
	end

	#The method create_temperatures is a loop for creating the forecasted temperatures by day
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

	#the method get_temp create a hash of days (day 1, day 2, ...) and array of forecasted temperature for each day
	#started from the initialized date
	#days { 1 => [23, 25, 18, ...], 2 => [19, 21, 22, ...]}
	def get_temp(data, location)
		@start = data["init"].last(2).to_i #to take the time (hour) when the data are initialized
		interval_days(data) #collecting the number of days of data (normally this number is 3 days) and the frequency (normally it's every 3 hours)
		all_days_temp = []
		data["dataseries"].each do |elem|
			all_days_temp << elem["temp2m"] #collecting all the forecasted temperatures in an array
		end		
		timezone = Timezone.lookup(location.latitude, location.longitude).utc_offset / 3600 #collecting the timezone of the location from the API GeoNames (see the initialize timezone.rb)
		@start = @start + timezone + @frequency_hours #calculating the real hour for forecasted temperature
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
		days[i-1].pop(to_delete) #if there is data in the first day, so the last day has null data because we don't have data for 24 hours for the last day
		date = DateTime.parse(data["init"]).to_date
		create_temperatures(days, location, date)
	end

	def get_data
		if params[:location].present? #with this condition we can synchronize only one location, url: POST /synchronize?location=slug_name
			@location = Location.friendly.find(params[:location])
			find_data(@location)
		else #here we can synchronize all the locations, url: POST /synchronize
			@locations = Location.all
			@locations.each do |location|
				find_data(location)
			end
		end
		render json: "Synchronization successfully done"
	end

	#The method find_data collect data from 7timer
	def find_data(location) 
		@long = location.longitude
		@lat = location.latitude
		url = "https://www.7timer.info/bin/api.pl?lon=#{@long}&lat=#{@lat}&product=astro&output=json"
		response = RestClient.get(url)
		response_hash = JSON.parse(response)
		get_temp(response_hash, location)
	end
end
