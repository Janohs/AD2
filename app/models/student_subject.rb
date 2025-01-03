class StudentSubject < ApplicationRecord
  belongs_to :student, foreign_key: "StudentID"
  belongs_to :subject, foreign_key: "SubjectID"
end
