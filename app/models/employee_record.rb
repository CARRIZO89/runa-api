class EmployeeRecord < ApplicationRecord
  belongs_to :employee, foreign_key: :user_id

  def self.last_in_by_employee_id(employee_id)
  	where(out_employee: nil, user_id: employee_id).last
  end
end
