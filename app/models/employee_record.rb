class EmployeeRecord < ApplicationRecord
  belongs_to :employee, foreign_key: :user_id

  scope :get_records_pending_out, -> { where(in_employee: Date.today.beginning_of_day..Date.today.end_of_day).or where( out_employee: nil) }

  def self.last_in_by_employee_id(employee_id)
    where(out_employee: nil, user_id: employee_id).last
  end
end
