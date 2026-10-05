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
3 houses, 8 flats, and imports the last 3 full months + the current month from the API. The API is slow, so this takes about a minute.

Tests with RSpec:

```
bundle exec rspec
```

## Importing data

From the terminal, to import the current month for all flats:

```
bin/rails import
```

Or from the "Import data" page in the interface, to import any date range.

Running an import again updates the values instead of duplicating them (upsert on location + start date).
In production, the import would run as a nightly job.

## Production

live at https://vrey-challenge.onrender.com

Render or Heroku work well for a small team: no servers to manage, deploy by pushing the code.
With the free plan, the first visit might take about a minute. The free database expires after 30 days.

**Monitoring / Logging**
- Render calls `/up` to check that the app is running.
- CPU and memory in the "Metrics" tab on Render.
- Rails logs to STDOUT, visible in the "Logs" tab on Render.

**What I would add**
- Use an error tracker like Sentry, to be alerted when something breaks.
- Nightly import with a Render cron job, with an alert if failing.
- A paid plan, so the app does not sleep.

## Important code

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

## Notes about performance
The more I got into deploying the application, the more I started to see potential bottlenecks.

**The house show page reads a lot of rows :**
- one value every 15min, so ~96 values per day
- one house with 3 flats, circa: 17000 rows for one month. Rows are read on every click
- on local : 0.3s, for Render's free plan : 1s or 2s
- with more flats and months, it only gets worse

Improvement : Store the total per day (one entry per meter per day). A month would become ~ 30 entries per meter instead of thousands.

**Import is slow**
- API call takes around 4s, it needs to do 2 calls per flat
- 1min 20s for ~9 flats, it would be 15min for 100 flats

Improvement : 
First, run the import in a background job, at night, and potentially one background job per flat, so the job queue runs several of them at the same time.
And possibly add threads in the import, so Ruby can wait on several network calls at the same time. (with limitation so we don't flood the API)
