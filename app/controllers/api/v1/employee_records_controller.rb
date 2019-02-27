class Api::V1::EmployeeRecordsController < Api::V1::BaseApiController

  def index
    @employee_records = EmployeeRecord.all
    render json: {employee_records: @employee_records}
  end

  def show
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

  def destroy
    @employee_record.destroy
    respond_to do |format|
      format.html { redirect_to employee_records_url, notice: 'Employee record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
