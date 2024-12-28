class Grade < ApplicationRecord
  belongs_to :student, foreign_key: "StudentID"
  belongs_to :subject, foreign_key: "SubjectID"
  self.primary_key = "GradeID"

  before_create :generate_grade_id

  private

  def generate_grade_id
    self.GradeID = SecureRandom.uuid if self.GradeID.blank?
  end
end
