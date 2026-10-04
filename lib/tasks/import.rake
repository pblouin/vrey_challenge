desc "Import this month measurements for all consumers"
task import: :environment do
  MeasurementImport.call(Date.current.beginning_of_month..Date.current)
end
