class Api::V1::EmployeesController < Api::V1::BaseApiController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = Employee.all
    render json: {employees: @employees}
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, root: :employee, status: :created
    else
      render json: { errors: @employee.errors } , status: :unprocessable_entity
    end
  end

  def update
    @employee.update(employee_params)
    render json: @employee, root: :employee
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :legajo, :email, :password)
    end
end
