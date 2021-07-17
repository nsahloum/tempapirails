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

	def show_location_temp
		@location = Location.friendly.find(params[:location_id])
        @forecasted_temperatures = @location.forecasted_temperatures
        render json: @forecasted_temperatures
	end
end
