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
    #verify that we create a location with all the parameter needed and a valid latitude and longitude
	def create 
		if params[:longitude].present? && params[:latitude].present? && params[:slug_name].present? && params[:longitude].to_i.between?(-180,180) && params[:latitude].to_i.between?(-90,90)
			@location = Location.create(
				longitude: params[:longitude],
				latitude: params[:latitude],
				slug_name: params[:slug_name]
			)
			find_data(@location) #when creating a location we need to directly get the forecasted temperature from 7timer see application_controller.rb
			if @location.id != nil
				render json: @location.forecasted_temperatures.as_json(
					only: [:date_forecasted, :min_forecasted, :max_forecasted]
				)
			elsif @location.id == nil #there is uniqueness for the slug_name so if id == nil, that means that the location hasn't been created because it already exists
				render json: "ERROR:1 : This location already exists"
			end
		else
			render json: "ERROR:2 : You must specify a valid longitude, latitude and a slug_name"
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