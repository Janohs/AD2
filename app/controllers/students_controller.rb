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

  def canteen
    @student = Student.find(params[:id])
    # Add any logic needed for the student's canteen page
    @payments = Payment.where(StudentID: @student.id) # for specific student
  end

  def add_payment
    @student = Student.find(params[:id])
    payment_id = SecureRandom.uuid
    amount = params[:amount].to_f  # Changed this line to access nested params

    @payment = Payment.new(
      PaymentID: payment_id,
      StudentID: @student.id,
      Amount: amount,
      ReceiptURL: nil
    )

    if @payment.save
      flash[:notice] = "Payment added successfully."
      redirect_to student_canteen_path(@student)
    else
      flash[:alert] = "Failed to add payment: #{@payment.errors.full_messages.join(', ')}"
      redirect_to student_canteen_path(@student)
    end
  end

  def profile
    @student = Student.find(params[:id])
    # Add any logic needed for the student's profile page
  end

  def merit
    @student = Student.find(params[:id])
    @merits = Merit.where(StudentID: @student.id, status: true) # Fetch merits for specific student
    # Add any logic needed for the student's merit page
  end

  def add_merit
    @student = Student.find(params[:id])
    @merit = Merit.new(merit_params.merge(StudentID: @student.id))
    if @merit.save
      redirect_to merit_student_path(@student), notice: "Merit added successfully."
    else
      redirect_to merit_student_path(@student), alert: "Failed to add merit."
    end
  end


  def exam
    @student = Student.find(params[:id])
    @subjects = Subject.where(StudentID: @student.id).includes(:grades) # Fetch subjects and their grades for specific student
  end

# app/controllers/students_controller.rb

# app/controllers/students_controller.rb

def download_exam_report
  @student = Student.find(params[:id])
  @subjects = Subject.where(StudentID: @student.id).includes(:grades)

  respond_to do |format|
    format.html
    format.pdf do
      pdf = Prawn::Document.new(page_size: "A4", margin: [ 30, 30, 30, 30 ]) do |pdf|
        # Header with orange background
        pdf.fill_color "E57E0C"
        pdf.rectangle [ 0, pdf.cursor ], pdf.bounds.width, 80
        pdf.fill

        pdf.move_down 20

        # Student information in white
        pdf.fill_color "FFFFFF"
        pdf.text_box "NAME: #{@student.StudentName}", at: [ 30, pdf.cursor ]
        pdf.move_down 20
        pdf.text_box "CLASS: #{@student.StudentClass}", at: [ 30, pdf.cursor ]
        pdf.move_down 20
        pdf.text_box "STUDENT ID: #{@student.StudentID}", at: [ 30, pdf.cursor ]

        # Reset position and color for main content
        pdf.move_down 100
        pdf.fill_color "000000"

        # Title
        pdf.text "Exam Report", size: 24, style: :bold
        pdf.move_down 20

        # Create table data
        table_data = []
        table_data << [ "Subject", "Grade" ]  # Header row

        @subjects.each do |subject|
          grades = subject.grades.map(&:Grade).join(", ")
          table_data << [ subject.Name, grades.presence || "No grades available" ]
        end

        # Draw table
        pdf.table(table_data, position: :center, width: pdf.bounds.width) do |t|
          t.header = true
          t.row(0).font_style = :bold
          t.row(0).background_color = "E57E0C"
          t.row(0).text_color = "FFFFFF"
          t.cells.padding = 12
          t.cells.borders = [ :bottom ]
          t.cells.border_width = 0.5
          t.cells.border_color = "CCCCCC"

          # Alternate row colors
          t.cells.style do |c|
            if c.row.odd? && c.row != 0
              c.background_color = "F9F9F9"
            end
          end
        end

        # Footer with page numbers
        pdf.page_count.times do |i|
          pdf.go_to_page(i + 1)
          pdf.bounding_box([ 0, 0 ], width: pdf.bounds.width, height: 30) do
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            pdf.text "Page #{i + 1} of #{pdf.page_count}", align: :center
          end
        end
      end

      # Send the PDF as a download
      send_data pdf.render,
                filename: "#{@student.StudentName.downcase.gsub(' ', '_')}_exam_report.pdf",
                type: "application/pdf",
                disposition: "attachment"
    end
  end
end

  private

  def merit_params
    params.require(:merit).permit(:meritPoint, :feedback)
  end
end
