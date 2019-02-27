class AddInOutToEmployeeRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_records, :in_employee, :datetime
    add_column :employee_records, :out_employee, :datetime
  end
end
