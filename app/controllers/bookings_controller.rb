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
    if @booking.save
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
    
    # Placeholder for penalty logic if cancelled < 1 hour prior
    # if @booking.time < Time.zone.now + 1.hour
    #   apply_penalty
    # end
    
    @booking.destroy
    redirect_to root_path, notice: "Booking was successfully cancelled."
  end

  private

  def booking_params
    params.require(:booking).permit(:court_id, :time)
  end
end
