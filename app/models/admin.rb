class Admin < ApplicationRecord
  self.primary_key="AdminID"

  validates :email, presence: true, uniqueness: true

  # Method to set the password (plain text)
  def password=(new_password)
    self.password = new_password
  end

  # Method to authenticate the password (plain text)
  def authenticate(password)
    self.password == password
  end
end
