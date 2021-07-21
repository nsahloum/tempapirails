Rails.application.routes.draw do
  resources :locations do
	resources :forecasted_temperatures
  end

  #URL to synchronize all the locations or one location by adding location parameter : /synchronize?location=slug_name
  #the CRON job can be send on this url
  #example of crontab lanch every days at 18:30 :
  # 30 18 * * * /usr/bin/curl -X POST http://127.0.0.1:3000/temperatures/synchronize
  post '/synchronize' => 'application#get_data'

  #getting all forecasted temperatures for one location
  get '/:location_id', to: 'forecasted_temperatures#show_location_temp'
  
end
