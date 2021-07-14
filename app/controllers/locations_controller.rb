class LocationsController < ApplicationController
	
	require 'rest-client'
	require 'json'

	def get_temp
		url = "https://www.7timer.info/bin/api.pl?lon=#{longitude}&lat=#{latitude}&product=astro&output=json"
		response = RestClient.get(url)
		response_hash = JSON.parse(response)
	end
	
	def index
        @locations = Location.all 
		@locations = @locations.filter_by_slug(params[:slug]) if params[:slug].present?
		# @locations.each do |location|
		# 	render json: location.forecasted_temperatures[0].min_forecasted
		# end
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
        render json: @location
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