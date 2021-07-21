Rails.application.routes.draw do
  resources :locations do
	resources :forecasted_temperatures
  end

  #URL to synchronize all the locations or one location by adding location parameter : /synchronize?location=slug_name
  post '/synchronize' => 'application#get_data'

  #getting all forecasted temperatures for one location
  get '/:location_id', to: 'forecasted_temperatures#show_location_temp'
  
end
