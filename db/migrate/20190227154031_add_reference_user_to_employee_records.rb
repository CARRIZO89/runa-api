class AddReferenceUserToEmployeeRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :employee_records, :user, foreign_key: true
  end
end
