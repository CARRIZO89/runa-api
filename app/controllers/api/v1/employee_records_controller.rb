module Api
  module V1
    class EmployeeRecordsController < Api::V1::BaseApiController

      def index
        @employee_records = EmployeeRecord.get_records_pending_out
        render json: { employee_records: @employee_records }
      end

      def show
      end

      def update
        record = EmployeeRecord.find(params[:id])
        if record.update(update_params)
          render json: record, root: :employee_record
        else
          render json: { errors: record.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee_record.destroy
        respond_to do |format|
          format.html { redirect_to employee_records_url, notice: 'Employee record was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      def update_params
        params.require(:employee_record).permit(:in_employee, :out_employee)
      end
    end
  end
end