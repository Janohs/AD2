# app/controllers/students_controller.rb
class StudentsController < ApplicationController
  def show
    @student = Student.find(params[:id])
  end

  def search
    if params[:query].present?
      begin
        # Disable prepared statements for this query
        @student = Student.connection.unprepared_statement do
          Student.where('"StudentName" ILIKE ?', "%#{params[:query]}%").first
        end

        if @student
          redirect_to student_path(@student)
        else
          flash[:alert] = "No student found with the name '#{params[:query]}'"
          render :search
        end
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "No student found with the name '#{params[:query]}'"
        render :search
      rescue StandardError => e
        flash[:alert] = "An error occurred: #{e.message}"
        render :search
      end
    else
      flash[:alert] = "Please enter a search query"
      render :search
    end
  end

  def dashboard
    @student = Student.find(params[:id])
    # Add any additional logic needed for the student's dashboard
  end
end
