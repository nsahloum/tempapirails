class LocationsController < ApplicationController
	
	require 'rest-client'
	require 'json'
	
	def index
        @locations = Location.all 
		render json: @locations
    end 

    def show
        @location = Location.friendly.find(params[:id])
        render json: @location
    end 

    def create
        @location = Location.create(
            latitude: params[:latitude],
            longitude: params[:longitude],
            slug_name: params[:slug_name]
        )
		if @location.id != nil
        	render json: @location
		else 
			render json: "This location already exists"
		end
    end 

    def update
        @location = Location.find(params[:id])
        @location.update(
            latitude: params[:latitude],
            longitude: params[:longitude],
            slug_name: params[:slug_name]
        )
        render json: @location
    end 

    def destroy
        @locations = Location.all 
        @location = Location.friendly.find(params[:id])
		@forecasted_temperatures = @location.forecasted_temperatures
		@forecasted_temperatures.each do |fore_temp|
			fore_temp.destroy
		end
        @location.destroy
        render json: @locations
    end 
end