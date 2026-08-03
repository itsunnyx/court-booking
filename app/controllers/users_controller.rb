class UsersController < ApplicationController
  def add_credit
    amount = params[:amount].to_i
    if amount > 0
      current_user.update(credit: current_user.credit + amount)
      redirect_back fallback_location: root_path, notice: "Credits successfully added!"
    else
      redirect_back fallback_location: root_path, alert: "Invalid amount."
    end
  end
end
