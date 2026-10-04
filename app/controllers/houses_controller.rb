class HousesController < ApplicationController
  rescue_from Date::Error, with: :invalid_date

  def index
    @houses = House.includes(:consumers)
  end

  def show
    @house = House.find(params[:id])
    @months_with_data = @house.months_with_data

    @flat = @house.consumers.find(params[:flat_id]) if params[:flat_id].present?
    @house_or_flat = @flat || @house
    @per_flat = params[:per_flat].present? && @flat.nil?

    @day = params[:day]&.to_date
    @month = selected_month
    @period = @day ? @day..@day : @month.all_month
    @calendar_month = params[:calendar]&.to_date
    @calendar_year = params[:calendar_year]&.to_i

    @days = @house_or_flat.days_with_data(@period)
    @has_data = @days > 0
  end

  private

  # Month from the URL, else the month of the selected day, else the last month with data
  def selected_month
    if params[:month].present?
      params[:month].to_date
    elsif @day
      @day.beginning_of_month
    elsif @months_with_data.any?
      @months_with_data.last
    else
      Date.today.beginning_of_month
    end
  end

  def invalid_date
    redirect_to house_path(params[:id])
  end
end
