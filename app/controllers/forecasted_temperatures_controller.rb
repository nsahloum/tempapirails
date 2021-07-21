class ForecastedTemperaturesController < ApplicationController

	require 'date'

	def valid_date?(date)
  		date_format = '%Y-%m-%d'
  		DateTime.strptime(date, date_format)
  		true
	rescue ArgumentError
 		false
	end

	#this method shows forecasted temperature for one location. url GET /slug_name

	def show_location_temp

		if Location.where(slug: params[:location_id]).exists?
			@location = Location.friendly.find(params[:location_id])
		end

		if @location == nil
			render json: "ERROR:3 : No forecasted temperatures saved for this location"
		elsif params[:start_date].present? == false && params[:end_date].present? == false
			@forecasted_temperatures = @location.forecasted_temperatures
		elsif ((params[:start_date].present? && valid_date?(params[:start_date]) == false) || (params[:end_date].present? && valid_date?(params[:end_date]) == false))
			render json: "ERROR:5 : Not valid date format (date format must be YYYY-MM-DD)"
		elsif params[:end_date].present? && params[:end_date].to_date < @location.created_at.to_date
			render json: "ERROR:4 : No forecasted temperatures saved for this date"
		elsif (params[:start_date].present? && params[:end_date].present? && params[:start_date] > params[:end_date])
			render json: "ERROR:6 : the start date must be before the end date"
		elsif (params[:start_date].present? && params[:end_date].present?)
			@start_date = params[:start_date].to_date
			@end_date = params[:end_date].to_date
	 		@forecasted_temperatures = @location.forecasted_temperatures.where(:date_forecasted => @start_date..@end_date)
		elsif (params[:start_date].present? && params[:end_date].present? == false)
			@start_date = params[:start_date].to_date
			@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted >= ?', @start_date)
		elsif (params[:end_date].present? && params[:start_date].present? == false)
			@end_date = params[:end_date].to_date
			@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted <= ?', @end_date)
		end
		if @forecasted_temperatures != nil
			render json: @forecasted_temperatures.as_json(
					only: [:date_forecasted, :min_forecasted, :max_forecasted]
				)
		end
	end
end