class ForecastedTemperaturesController < ApplicationController
	def index
        @forecasted_temperatures = ForecastedTemperature.all 
        render json: @forecasted_temperatures
    end 

    def show
        @forecasted_temperatures = ForecastedTemperature.find(params[:id])
        render json: @forecasted_temperature
    end 
end
