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
		if Location.where(slug: params[:location_id]).exists?
			@location = Location.friendly.find(params[:id])
			render json: @location.as_json(
				only: [:id, :latitude, :longitude, :created_at, :updated_at, :slug]
			)
		else
			render json: "ERROR:3 : No forecasted temperatures saved for this location or this location is not in the database
			"
		end
    end 

	def is_integer (coord)
		if coord.to_f.to_s == coord || coord.to_i.to_s == coord
			return true
		else
			return false
		end
	end

	#checking if valide coordinates
	def validate_coord(latitude, longitude)
		if (longitude.present? && latitude.present? && longitude.to_f.between?(-180,180) && latitude.to_f.between?(-90,90) && is_integer(latitude) && is_integer(longitude))
			return true
		else 
			return false
		end
	end

	# checking if the slug_name is url safe
	def validate_slug(slug_name)
		if (slug_name.present? && /^[a-zA-Z0-9_-]*$/.match(slug_name))
			return true
		else
			return false
		end
	end
	
	#create new location (url: /locations?longitude=lon&latitude=lat&slug_name=location,  POST)
    #verify that we create a location with all the parameter needed and a valid latitude and longitude
	def create 
		if validate_coord(params[:latitude], params[:longitude]) && validate_slug(params[:slug_name])
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

	#update an existing location (url: /locations/slug_name, PATCH)
    def update 
        @location = Location.find(params[:id])
        @location.update(
            latitude: params[:latitude],
            longitude: params[:longitude],
            slug_name: params[:slug_name]
        )
        render json: @location
    end 

	#delete an existing location (url: /locations/slug_name, DELETE)
    def destroy
        @locations = Location.all 
        @location = Location.friendly.find(params[:id])
        @location.destroy
        render json: @locations
    end 
end