Rails.application.routes.draw do
  resources :locations, only: [:index, :show, :create, :update, :destroy, :get_temp]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
