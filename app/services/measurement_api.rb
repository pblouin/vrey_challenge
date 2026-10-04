require "net/http"

class MeasurementApi
  BASE_URL = "https://mock-measurement-api-8fbe027730b7.herokuapp.com"

  def get_data(location_id, begin_date, end_date)
    uri = URI("#{BASE_URL}/values/#{location_id}/load-profile?beginDate=#{begin_date}&endDate=#{end_date}")

    response = Net::HTTP.get_response(uri)

    raise "#{location_id}: API responded #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
