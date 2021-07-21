class LocationsController < ApplicationController
	
	require 'rest-client'
	require 'json'

	#All CRUD functions for Locations
	
	#Read (List -> url: /locations, GET)
	def index
        @locations = Location.all 
		render json: @locations
    end 

	#Read (one location find by id = slug name of the location, 
	# example : london, url: /locations/slug, GET)
    def show
        @location = Location.friendly.find(params[:id])
        render json: @location
    end 

	#create new location (url: /locations?longitude=lon&latitude=lat&slug_name=location,  POST)
    def create 
        @location = Location.create(
            longitude: params[:longitude],
			latitude: params[:latitude],
            slug_name: params[:slug_name]
        )
		find_data(@location)
		if @location.id != nil
        	render json: @location.forecasted_temperatures.as_json(
				only: [:date_forecasted, :min_forecasted, :max_forecasted]
			)
		elsif @location.id == nil
			render json: "ERROR : This location already exists"
		end
    end 

	#update an existing location (url: /locations/slug_name)
    def update 
        @location = Location.find(params[:id])
        @location.update(
            latitude: params[:latitude],
            longitude: params[:longitude],
            slug_name: params[:slug_name]
        )
        render json: @location
    end 

	#delete an existing location (url: /locations/slug_name)
    def destroy
        @locations = Location.all 
        @location = Location.friendly.find(params[:id])
        @location.destroy
        render json: @locations
    end 
end