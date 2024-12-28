class TeachersController < ApplicationController
  def index
    @teachers = Teacher.all
  end

  def show
    @teachers = Teacher.find(params[:id])
  end

  def dashboard
    @teachers = Teacher.find(params[:id])
    # Add any additional logic needed for the admin's dashboard
  end

  def exam_report
    @teachers = Teacher.find(params[:id])
    if params[:query].present?
      begin
        # Disable prepared statements for this query
        @student = Student.connection.unprepared_statement do
          Student.where('"StudentName" ILIKE ?', "%#{params[:query]}%").first
        end

        if @student
          @subjects = @student.subjects.includes(:grades)
        else
          flash[:alert] = "No student found with the name '#{params[:query]}'"
          @subjects = []
        end
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "No student found with the name '#{params[:query]}'"
        @subjects = []
      rescue StandardError => e
        flash[:alert] = "An error occurred: #{e.message}"
        @subjects = []
      end
    else
      flash[:alert] = "Please enter a search query"
      @subjects = []
    end
  end

  def update_grades
    grades_params.each do |id, grade_params|
      grade = Grade.find(id)
      grade.update(grade_params)
    end
    render json: { success: true }
  rescue StandardError => e
    render json: { success: false, error: e.message }
  end

  def add_student_to_subject
    @teachers = Teacher.find(params[:teacher_id])
    @subject = Subject.find(params[:subject_id])
    student_id = params[:student_id].to_i

    if @subject.students.exists?(student_id)
      flash[:alert] = "Student already added to this subject."
    else
      @subject.students << Student.find(student_id)
      flash[:notice] = "Student added to subject successfully."
    end

    redirect_to teacher_exam_report_path(@teachers)
  end

  private

  def grades_params
    params.require(:grades).permit!
  end

  def merit_demerit
  end
end
