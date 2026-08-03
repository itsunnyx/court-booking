class CourtsController < ApplicationController
  def deactivate
    unless is_admin?
      redirect_to root_path, alert: "Unauthorized"
      return
    end
    
    court = Court.find(params[:court_id])
    date = Date.parse(params[:date])
    
    CourtDeactivation.find_or_create_by!(court: court, date: date)
    
    redirect_to root_path(date: date), notice: "#{court.name} has been deactivated for #{date.strftime('%B %d, %Y')}."
  end

  def reactivate
    unless is_admin?
      redirect_to root_path, alert: "Unauthorized"
      return
    end
    
    court = Court.find(params[:court_id])
    date = Date.parse(params[:date])
    
    CourtDeactivation.where(court: court, date: date).destroy_all
    
    redirect_to root_path(date: date), notice: "#{court.name} has been reactivated for #{date.strftime('%B %d, %Y')}."
  end
end
