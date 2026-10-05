# VREY challenge

A small Rails application that imports energy data from the VREY test API and shows the solar consumption of houses using GGV.

For each house, you can see:
- the total solar and grid consumption
- the average solar consumption per day
- the share between solar and grid
- how the solar is split between the flats

At the top, the Monthly / Daily toggle button changes the period. You can pick a month or a day with the arrows or the calendar.

Below, you can select the whole house or a single flat.
The chart shows the consumption per day (monthly view) or per quarter-hour (daily view).
For the whole house, it can show either solar / grid or the consumption of each flat.

## Setup and installation

Ruby 3.4.8, Rails 8.1, PostgreSQL.

```
bundle install
bin/rails db:setup
bin/dev
```

Interface at http://localhost:3000

`db:setup` also runs the demo seed:
3 houses, 8 flats, and imports the last three 3 months from the API. The API is slow, so this takes about a minute.

## Importing data

From the terminal, to import the current month for all flats:

```
bin/rails import
```

Or from the "Import data" page in the interface, to import any date range.

Running an import again updates the values instead of duplicating them (upsert on location + start date).
In production, the import would run as a nightly job.

## Code worth a look

- `app/services/measurement_api.rb`: API client
- `app/services/measurement_import.rb`: imports and parses the data
- `app/models/concerns/consumption.rb`: the calculations (solar, grid, share, per day), shared by houses and flats
- `app/controllers/houses_controller.rb`: reads the selected month, day and flat from the URL
- `app/javascript/controllers/chart_controller.js`: chart with Chart.js

## Notes

- The API returns random values on every call, so the flats look almost the same, around 75% solar.
- Times are stored in UTC and shown in Berlin time.

## Ideas (with more time)

- Nightly import as a background job
- Business oriented data: savings in € for tenants (solar vs grid price), CO2 savings for landlords
- Login, roles and permissions + landlords/tenants have different interfaces
