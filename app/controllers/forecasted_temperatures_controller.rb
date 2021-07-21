class ForecastedTemperaturesController < ApplicationController

	#this method shows forecasted temperature for one location. url GET /slug_name
	require 'date'
	# def validate_date(datum)
	# 	if Date.valid_date?(datum) == true
	# 		return true
	# 	else
	# 		render json: "ERROR:5 : Date format no valid"
	# 	end
	# end

	def validate_date?(date)
  		date_format = '%Y-%m-%d'
  		DateTime.strptime(date, date_format)
 	 	true
	rescue ArgumentError
  		false
	end

	def show_location_temp
		if Location.where(slug: params[:location_id]).exists?
			@location = Location.friendly.find(params[:location_id])
        	@forecasted_temperatures = @location.forecasted_temperatures
			if params[:start_date].present? && params[:end_date].present? && validate_date?(params[:start_date]) && validate_date?(params[:end_date])#to filter by start date and end date, url GET /slug_name?start_date=""&end_date=""
				@start_date = params[:start_date].to_date
				@end_date = params[:end_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where(:date_forecasted => @start_date..@end_date)
				if @forecasted_temperatures.first == nil
					render json: "ERROR:4 : No forecasted temperatures saved for this date"
				end
			elsif params[:start_date].present? && validate_date?(params[:start_date]) && params[:end_date].present? == false #show all the forecasted temperature from start date (if only start_date specified)
				@start_date = params[:start_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted >= ?', @start_date)
			elsif params[:end_date].present? && validate_date?(params[:end_date]) && params[:start_date].present? == false #show all the forecasted temperature before end date (if only end_date specified)
				@end_date = params[:end_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted <= ?', @end_date)
			elsif params[:start_date].present? == false && params[:end_date].present? == false
				@forecasted_temperatures = @location.forecasted_temperatures #if no params, show all the forecasted_temepratures for a location
			end
		else 
			render json: "ERROR:3 : No forecasted temperatures saved for this location"
		end
		render json: @forecasted_temperatures.as_json(
				only: [:date_forecasted, :min_forecasted, :max_forecasted]
			)
	end
end