class CreateEmployeeRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_records do |t|

      t.timestamps
    end
  end
end
