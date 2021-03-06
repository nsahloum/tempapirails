# Forecasted Temperature for locations API (Ruby on Rails)

> **Environment:**<br>
> Ruby 3.0.2 <br>
> Rails 6.1.4 <br>
> url : https://forecasted-temperature.herokuapp.com/

## CRUD operations on locations<br>

### 1. Create location:

> POST request on: domain_name/locations?longitude=lon&latitude=lat&slug_name=location

example: domain_name/locations?longitude=4.352&latitude=50.85&slug_name=brussels
<br>
<br>**Notes:** 
- the precision of longitude and latitude is 0.001
- slug_name: name for the location that’s URL-safe
- when a location is created, the current forecasted temperatures present on 7timer.info are automatically added

### 2. Read location(s):
- List all locations (data listed: id of the location, latitude, longitude, date of creation, date of last update, name of location (slug))
> GET request on: domain_name/locations

- List one specific location (data listed: id of the location, latitude, longitude, date of creation, date of last update, name of location (slug))
> GET request on: domain_name/locations/slug_name

example: domain_name/locations/brussels

- List all forecasted temperatures for one location (data listed: date, max forecasted, min forecasted)
> GET request on: domain_name/slug_name

example: domain_name/brussels

### 3. Update location:

> PATCH request on: domain_name/locations/id?longitude=4.352&latitude=50.85&slug_name=brussels 
> Or domain_name/locations/slug_name?longitude=4.352&latitude=50.85&slug_name=brussels 

example: domain_name/locations/1?longitude=4.352&latitude=50.85&slug_name=brussels<br>
or domain_name/locations/brussels?longitude=4.352&latitude=50.85&slug_name=brussels

**Note:**
- You can get the id of a location by listing one specific location (see above)
- The user must specify the three parameter even if it's not changed

### 4. Delete location:

> DELETE request on: domain_name/locations/slug_name

example : domain_name/locations/brussels

## Filter forecasted temperatures by dates:
(data listed: date, max forecasted, min forecasted) <br>
Note that the dates specified are the real dates for each location (in the timezone of the location)
### 1. Between two dates
> GET request on: domain_name/location?start_date=""&end_date=""<br>

date format: YYYY-MM-DD <br>
example: domain_name/brussels?start_date=2021-07-19&end_date=2021-07-20

### 2. All forecasted temperatures from a start date:
> GET request on: domain_name/location?start_date=""

example: domain_name/brussels?start_date=2021-07-19

### 3. All forecasted temperatures before an end date:
> GET request on: domain_name/location?end_date=""

example: domain_name/brussels?end_date=2021-07-20

## Synchronize data from 7Timer API (adding new forecasted temperatures)

### 1. Synchronize all locations temperatures:

> POST request on: domaine_name/synchronize

#### Create a CRON job on this url
- example of CRON job on localhost to synchronize data every days at 18:30 :<br>
> 30 18 * * * /usr/bin/curl -X POST http://127.0.0.1:3000/synchronize

### 2. Synchronize one specific location

> POST request on: domaine_name/synchronize?location=slug_name

example: domaine_name/synchronize?location=brussels

## Errors and info handeling

> ERROR:1 : This location already exists

ERROR:1 Explanation : 
- if a user try to create a location with a slug_name that already exists

> ERROR:2 : You must specify a valid longitude, latitude and a slug_name

ERROR:2 Explanation : 
- if a user don't specify all the three parameters (longitude, latitude and slug_name) 
- or a user enter a non-valid longitude (must be between -180 and 180) or latitude (must be between -90 and 90)
- or longitude and latitude are not float
- or a no URL safe slug_name

> ERROR:3 : This location doesn't exist

ERROR:3 Explanation : 
- if a user ask for location that is not yet in the database

> ERROR:4 : No forecasted temperatures saved for this date

ERROR:4 Explanation : 
- if a user ask for forecasted temperatures before the date of creation of the location in the database 
- because it's impossible to get past forecasted temperature in 7Timer but this API can store the data starting from location's date of creation.

> ERROR:5 : Not valid date format (date format must be YYYY-MM-DD)

ERROR:5 Explanation:
- if a user enter a invalid date format, the date must be YYYY-MM-DD

> ERROR:6 : the start date must be before the end date

ERROR:6 Explanation
- the user must specify a start date that is before the end date

> INFO:1: Synchronization successfully done

INFO:1 Explanation : when the synchronization of one location or all locations is done

> INFO:2 : You just changed the slug_name, you can access this location with the new slug_name

INFO:2 Explanation : when updating a location slug_name, the location is not accessible anymore by this slug_name

