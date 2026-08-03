class BookingsController < ApplicationController
  def new
    @court = Court.find(params[:court_id])
    hour = params[:hour].to_i
    date = Date.parse(params[:date])
    # Combine date and hour
    time = Time.zone.local(date.year, date.month, date.day, hour)
    @booking = Booking.new(court: @court, time: time)
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    
    if CourtDeactivation.exists?(court_id: @booking.court_id, date: @booking.time.to_date)
      redirect_to root_path(date: @booking.time.to_date), alert: "This court is deactivated on this date."
      return
    end

    if current_user.credit < 500
      redirect_to root_path, alert: "Insufficient credits. You need 500 credits to make a booking."
      return
    end

    if @booking.save
      current_user.update(credit: current_user.credit - 500)
      redirect_to root_path, notice: "Booking was successfully created."
    else
      @court = @booking.court
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    @booking = current_user.bookings.find(params[:id])
  end

  def destroy
    @booking = current_user.bookings.find(params[:id])
    
    time_until_booking = @booking.time - Time.zone.now
    
    if time_until_booking > 1.hour
      current_user.update(credit: current_user.credit + 500)
      notice = "Booking was successfully cancelled and 500 credits were refunded."
    else
      current_user.update(credit: current_user.credit + 250)
      notice = "Booking was cancelled. 250 credits were refunded (50% penalty for late cancellation)."
    end
    
    @booking.destroy
    redirect_to root_path, notice: notice
  end

  private

  def booking_params
    params.require(:booking).permit(:court_id, :time)
  end
end
