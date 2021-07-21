class ForecastedTemperaturesController < ApplicationController

	#this method shows forecasted temperature for one location. url GET /slug_name
	def show_location_temp
		if Location.where(slug: params[:location_id]).exists?
			@location = Location.friendly.find(params[:location_id])
        	@forecasted_temperatures = @location.forecasted_temperatures
			if params[:start_date].present? && params[:end_date].present? #to filter by start date and end date, url GET /slug_name?start_date=""&end_date=""
				@start_date = params[:start_date].to_date
				@end_date = params[:end_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where(:date_forecasted => @start_date..@end_date)
			elsif params[:start_date].present? #show all the forecasted temperature from start date (if only start_date specified)
				@start_date = params[:start_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted >= ?', @start_date)
			elsif params[:end_date].present? #show all the forecasted temperature before end date (if only end_date specified)
				@end_date = params[:end_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted <= ?', @end_date)
			else
				@forecasted_temperatures = @location.forecasted_temperatures #if no params, show all the forecasted_temepratures for a location
			end
		end
		if @location == nil #if the location is not in the database
			render json: "ERROR:3 : No forecasted temperatures saved for this location"
		elsif @forecasted_temperatures.first == nil #if no temperatures are saved for this location
			render json: "ERROR:4 : No forecasted temperatures saved for this date"
		else
			render json: @forecasted_temperatures.as_json(
				only: [:date_forecasted, :min_forecasted, :max_forecasted]
			)
		end
	end
end