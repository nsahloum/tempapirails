# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

location1 = Location.create(latitude: 50.8503, longitude: 4.3517, slug_name: "brussels")
location2 = Location.create(latitude: 48.8566, longitude: 2.3522, slug_name: "paris")
location3 = Location.create(latitude: 51.5074, longitude: 0.1278, slug_name: "london")