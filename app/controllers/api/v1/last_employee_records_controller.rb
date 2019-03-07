class Api::V1::LastEmployeeRecordsController < Api::V1::BaseApiController
	def show
		last = EmployeeRecord.last_in_by_employee_id(params[:employee_id])
		if last
			render json: last, root: :employee_record
		else	
			render json: { error: :not_found }, status: 404
		end
	end
end