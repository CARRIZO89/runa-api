class Employee < User
  has_many :employee_records, foreign_key: :user_id
end
