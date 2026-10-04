class ImportsController < ApplicationController
  rescue_from Date::Error, with: :invalid_date

  def new
    @start_date = params[:start_date]&.to_date || Date.current.beginning_of_month
    @end_date = params[:end_date]&.to_date || Date.current
    @start_date_calendar = params[:start_date_calendar]&.to_date
    @end_date_calendar = params[:end_date_calendar]&.to_date
  end

  def create
    start_date = params.require(:start_date).to_date
    end_date = params.require(:end_date).to_date

    if start_date > end_date
      redirect_to new_import_path(start_date: start_date, end_date: end_date), alert: "The start date must be before the end date."
      return
    end

    MeasurementImport.call(start_date..end_date)
    redirect_to root_path, notice: "Data imported from #{l start_date, format: "%-d %B %Y"} to #{l end_date, format: "%-d %B %Y"}."
  end

  private

  def invalid_date
    redirect_to new_import_path, alert: "Invalid date."
  end
end
