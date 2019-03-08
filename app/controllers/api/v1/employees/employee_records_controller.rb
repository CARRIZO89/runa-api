module Api
  module V1
    module Employees
      class EmployeeRecordsController < Api::V1::BaseApiController
        before_action :set_employe, only: [:index]

        def index
          @employee_records = @employee.employee_records
          render json: @employee_records, status: 200
        end

        def create
          @employee_record = EmployeeRecord.new(
            user_id: params[:employee_id],
            in_employee: Time.now
          )

          if @employee_record.save
            render json: @employee_record, root: :employee_record, status: :created
          else
            render json: { errors: @employee_record.errors}, status: :unprocessable_entity  
          end
        end

        def update
          @record = EmployeeRecord.last_in_by_employee_id(params[:employee_id])
          @record.update(out_employee: Time.now)
          render json: @record, root: :employee_record
        end

        private
        def set_employe
          @employee = Employee.find(params[:employee_id])
        end
      end
    end
  end
end
