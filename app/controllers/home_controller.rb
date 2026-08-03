class HomeController < ApplicationController
  def index
    @courts = Court.all
    # Calendar logic
    @current_date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    
    # Keep the schedule table focused on the selected date
    today_bookings = Booking.includes(:user)
                            .where(time: @current_date.beginning_of_day..@current_date.end_of_day)
    
    @bookings_by_court_and_hour = today_bookings.index_by { |b| [b.court_id, b.time.hour] }
    @hours = (6..23).to_a # 6 AM to 9 PM (slots ending at 10 PM)
    
    # Calendar grid logic
    start_date = @current_date.beginning_of_month.beginning_of_week(:sunday)
    end_date = @current_date.end_of_month.end_of_week(:sunday)
    @calendar_days = (start_date..end_date).to_a
    
    @user_bookings_count_by_date = current_user.bookings
                                               .where(time: start_date.beginning_of_day..end_date.end_of_day)
                                               .pluck(:time)
                                               .map(&:to_date)
                                               .tally
  end
end
