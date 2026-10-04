desc "Import this month measurements for all consumers"
task import: :environment do
  MeasurementImport.call(Date.today.beginning_of_month..Date.today)
end
