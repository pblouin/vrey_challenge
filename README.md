# VREY challenge

A small rails application that imports energy data from testing VREY API and shows the solar consumption of houses using GGV.

For each house, you can see : 
- the total solar consumption
- the average solar consumption per day
- the share between solar / grid
- how the solar is split between the flats

## Setup and installation

Ruby 3.4.8, Rails 8.1, PostgreSQL.

```
bundle install
bin/rails db:setup
bin/dev
```

Interface at http://localhost:3000

`db:setup` also runs the demo seed: 
3 houses, 8 flats, and imports last month from the API. The API is slow, so this takes about a minute.

## Importing data

```
bin/rails import
```

It imports the current month for all consumers. 
Running it again updates the values instead of duplicating them (upsert on location + start date).

I kept the import as a rake task. 
In production it would run as a nightly job, not from a button.

## Noticeable code : 

- `app/services/measurement_api.rb`: API client
- `app/services/measurement_import.rb`: Import and parse the data
- `app/services/house_consumption_report.rb`: Pre-calculate the numbers shown in the view
- `app/javascript/controllers/chart_controller.js`: use Chart.js for charts

## Notes

- The API returns random values on every call, so the flats look almost the same, 75% solar. 

## Ideas (with more time)
- Background job nightly import
- Display savings for tenants (solar vs grid price)
- A typical day profile from the 15-minute data
- Login with roles and permissions, so landlords and tenants can have different interfaces