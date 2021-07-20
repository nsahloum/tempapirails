class ForecastedTemperaturesController < ApplicationController
	def show_location_temp
		if Location.where(slug: params[:location_id]).exists?
			@location = Location.friendly.find(params[:location_id])
			@long = @location.longitude
			@lat = @location.latitude
        	@forecasted_temperatures = @location.forecasted_temperatures
			first_date = @forecasted_temperatures.first.date_forecasted
			if params[:start_date].present? && params[:end_date].present?
				@start_date = params[:start_date].to_date
				@end_date = params[:end_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where(:date_forecasted => @start_date..@end_date)
			elsif params[:start_date].present?
				@start_date = params[:start_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted >= ?', @start_date)
			elsif params[:end_date].present?
				@end_date = params[:end_date].to_date
				@forecasted_temperatures = @location.forecasted_temperatures.where('date_forecasted <= ?', @end_date)
			else
				@forecasted_temperatures = @location.forecasted_temperatures
			end
		end
		if @location == nil
			render json: "Sorry no forecasted temperatures saved for this location"
		elsif @forecasted_temperatures.first == nil
			render json: "Sorry no forecasted temperatures saved for this date"
		else
			render json: @forecasted_temperatures.as_json(
				only: [:date_forecasted, :min_forecasted, :max_forecasted]
			)
		end
	end
end
