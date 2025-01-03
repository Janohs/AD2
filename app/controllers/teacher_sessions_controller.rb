class TeacherSessionsController < ApplicationController
  def index
    # Render the teacher login form
  end

  def create
    teacher = Teacher.find_by(email: params[:email])
    if teacher && teacher.authenticate(params[:password])
      session[:teacher_id] = teacher.id
      redirect_to teacher_dashboard_path(teacher), notice: "Logged in successfully"
    else
      flash[:alert] = "Invalid email or password"
      render :index
    end
  end

  def destroy
    session[:teacher_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
