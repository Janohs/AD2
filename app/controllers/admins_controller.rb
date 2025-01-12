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
    @student_count=Student.count
    @unique_classes_count= Student.select(:StudentClass).distinct.count
    @unverified_merits_count= Merit.where(status:false).count
  end

  def verify_merit_demerit
    @merits = Merit.page(params[:page]).per(10) # Paginate merits, 10 per page
  end

  def accept_merit
    @merit = Merit.find(params[:id])
    @merit.update(status: true)
    redirect_to verify_merit_demerit_admins_path, notice: "Merit status updated to Verified."
  end

  def class_ranking
    @students = Student.joins(subjects: :grades)
                       .select("students.*, AVG(grades.\"Grade\"::numeric) AS average_grade")
                       .group("StudentID")
                       .order("average_grade DESC")
  end

  def verify_payment
    @payments = Payment.all # Fetch all payments
  end
end
