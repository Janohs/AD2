class AdminsController < ApplicationController
  def index
    @admins = Admin.all
  end

  def show
    @admins = Admin.find(params[:id])
  end

  def dashboard
    @admins = Admin.find(params[:id])
    # Add any additional logic needed for the admin's dashboard
  end
end
