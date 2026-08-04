class HomeController < ApplicationController
  def index
    @all_courts = Court.order(:name)
    @selected_court = params[:court_id].present? ? @all_courts.find_by(id: params[:court_id]) : nil
    @selected_court ||= @all_courts.first
    @courts = [@selected_court].compact
    # Calendar logic
    current_local_date = Time.zone.now.to_date
    @current_date = params[:date].present? ? Date.parse(params[:date]) : current_local_date
    
    # Keep the schedule table focused on the selected date
    today_bookings = Booking.includes(:user)
                            .where(time: @current_date.beginning_of_day..@current_date.end_of_day)
    
    @bookings_by_court_and_hour = today_bookings.index_by { |b| [b.court_id, b.time.hour] }
    
    @deactivated_court_ids = CourtDeactivation.where(date: @current_date).pluck(:court_id)
    
    @hours = if @current_date < current_local_date
      []
    elsif @current_date == current_local_date
      (6..23).select { |h| h > Time.zone.now.hour }
    else
      (6..23).to_a
    end
    
    # Calendar grid logic
    start_date = @current_date.beginning_of_month.beginning_of_week(:sunday)
    end_date = @current_date.end_of_month.end_of_week(:sunday)
    @calendar_days = (start_date..end_date).to_a
    
    @user_bookings_count_by_date = if current_user
      current_user.bookings
                  .where(court_id: @selected_court.id, time: start_date.beginning_of_day..end_date.end_of_day)
                  .pluck(:time)
                  .map(&:to_date)
                  .tally
    else
      {}
    end
  end
end
