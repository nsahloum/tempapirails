class LocationsController < ApplicationController
	def index
        @locations = Location.all 
        render json: @locations
    end 

    def show
        @location = Location.find(params[:id])
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
        @location = Location.find(params[:id])
        @location.destroy
        render json: @locations
    end 
end