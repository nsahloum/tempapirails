# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

location1 = Location.create(latitude: 50.850, longitude: 4.351, slug_name: "brussels")

forecasted_temperatures1 = ForecastedTemperature.create(date_forecasted: Date.today, min_forecasted: 23, max_forecasted: 43, location_id: 1)
#forecasted_temperatures2 = ForecastedTemperature.create(date_forecasted: Date.today, min_forecasted: 23, max_forecasted: 43, location_id: 2)