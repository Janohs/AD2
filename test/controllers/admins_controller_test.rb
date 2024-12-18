require "test_helper"

class AdminsControllerTest < ActionDispatch::IntegrationTest
  def index
    @admins = Admin.all
  end

  def show
    @admins = Admin.find(params[:id])
  end

  def dashboard
    @admins = Admin.find(params[:id])
    # Add any additional logic needed for the student's dashboard
  end
end
