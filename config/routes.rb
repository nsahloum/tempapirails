Rails.application.routes.draw do
  #resources :forecasted_temperatures, only: [:index, :show, :destroy]
  #resources :locations, only: [:index, :show, :create, :update, :destroy, :get_temp]
  resources :locations do
	resources :forecasted_temperatures
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
