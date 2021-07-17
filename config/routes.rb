Rails.application.routes.draw do
  #resources :forecasted_temperatures, only: [:index, :show, :destroy]
  #resources :locations, only: [:index, :show, :create, :update, :destroy, :get_temp]
  resources :forecasted_temperatures 
  resources :locations do
	resources :forecasted_temperatures
  end
  get '/:location_id', to: 'forecasted_temperatures#show_location_temp'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
