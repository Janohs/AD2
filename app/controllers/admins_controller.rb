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
    # Start with all merits
    merits = Merit.page(params[:page]).per(10)

    # Filter by status if provided
    if params[:status].present?
      merits = merits.where(status: params[:status] == "verified")
    end

    # Filter by class if provided
    if params[:class].present?
      merits = merits.joins("INNER JOIN students ON students.\"StudentID\" = merits.\"StudentID\"")
                     .where("students.\"StudentClass\" = ?", params[:class])
    end

    @merits = merits
  end

  def accept_merit
    @merit = Merit.find(params[:id])
    @merit.update(status: true)
    redirect_to verify_merit_demerit_admins_path, notice: "Merit status updated to Verified."
  end

  def class_ranking
    # Start with all students
    students = Student.joins(subjects: :grades)
                      .select("students.*, AVG(grades.\"Grade\"::numeric) AS average_grade")
                      .group("StudentID")
                      .order("average_grade DESC")

    # Filter by class if provided
    if params[:class].present?
      students = students.where("students.\"StudentClass\" = ?", params[:class])
    end

    @students = students
  end

  def verify_payment
    # Start with all payments
    payments = Payment.all

    # Filter by status if provided
    if params[:status].present?
      payments = payments.where(status: params[:status] == "verified")
    end

    # Filter by class if provided
    if params[:class].present?
      payments = payments.joins("INNER JOIN students ON students.\"StudentID\" = payments.\"StudentID\"")
                         .where("students.\"StudentClass\" = ?", params[:class])
    end

    @payments = payments.page(params[:page]).per(10) # Paginate payments, 10 per page
  end

  def verify_payment_action
    @payment = Payment.find(params[:id])
    if @payment.update(status: true)
      redirect_to verify_payment_admins_path, notice: "Payment ##{@payment.PaymentID} has been successfully verified."
    else
      redirect_to verify_payment_admins_path, alert: "Failed to verify payment ##{@payment.PaymentID}. Please try again."
    end
  end
end
