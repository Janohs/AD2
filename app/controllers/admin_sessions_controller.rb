class AdminSessionsController < ApplicationController
  def index
    # Render the admin login form
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_dashboard_path(admin), notice: "Logged in successfully"
    else
      flash[:alert] = "Invalid email or password"
      render :index
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
