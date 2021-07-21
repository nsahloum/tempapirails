# Forecasted Temperature for locations API (Ruby on Rails)

> **Environment:**<br>
> Ruby 3.0.2 <br>
> Rails 6.1.4

## CRUD operations on locations<br>

### 1. Create location:

> POST request on: domain_name/locations?longitude=lon&latitude=lat&slug_name=location

example: domain_name/locations?longitude=4.352&latitude=50.85&slug_name=brussels
<br>
<br>**Notes:** 
- the precision of longitude and latitude is 0.001
- slug_name: name for the location that’s URL-safe

### 2. Read location(s):
- List all locations:
> GET request on: domain_name/locations

- List one specific location:
> GET request on: domain_name/locations/slug_name
example: domain_name/locations/brussels

- List all forecasted temperatures for one location:
> GET request on: domain_name/slug_name
example: domain_name/brussels

### 3. Update location:

> PATCH request on: domain_name/locations/id?longitude=4.352&latitude=50.85&slug_name=brussels

example: domain_name/locations/1?longitude=4.352&latitude=50.85&slug_name=brussels

Note:<br>
- You can get the id of a location by listing one specific location (see above)

### 4. Delete location:

> DELETE request on: domain_name/slug_name

## Filter forecasted temperatures by dates:
### Between two dates
> GET request on: domain_name/location?start_date=""&end_date=""<br>

date format: YYYY-MM-DD <br>
example: domain_name/brussels?start_date=2021-07-19&end_date=2021-07-20

### All forecasted temperatures from a start date:
> GET request on: domain_name/location?start_date=""

### All forecasted temperatures before an end date:
> GET request on: domain_name/location?end_date=""

## Synchronize data from 7Timer API (adding new forecasted temperatures)

### 1. Synchronize all locations temperatures:

> POST request on: domaine_name/synchronize

#### Create a CRON job on this url
- example of CRON job on localhost to synchronize data every days at 18:30 :<br>
> 30 18 * * * /usr/bin/curl -X POST http://127.0.0.1:3000/synchronize

### 2. Synchronize one specific location

> POST request on: domaine_name/synchronize?location=slug_name

example: domaine_name/synchronize?location=brussels
