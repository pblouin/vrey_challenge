require "rails_helper"

RSpec.describe "Houses", type: :request do
  it "shows the house page" do
    house = House.create!(name: "Kopenhagener Str. 1")

    get house_path(house)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Kopenhagener Str. 1")
  end
end
