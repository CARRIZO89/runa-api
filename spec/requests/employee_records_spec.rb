require 'rails_helper'

RSpec.describe "EmployeeRecords", type: :request do
  describe "GET /api/v1/employee_records" do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    context "get employee records" do
      it "get employee records pending out" do
        employee_1 = Employee.create(first_name: 'Miguel', last_name: 'Carrizo', legajo: '1', email: 'miguel@m.com', password: '123456')
        employee_2 = Employee.create(first_name: 'Maria', last_name: 'Carrizo', legajo: '2', email: 'maria@m.com', password: '123456')
        employee_3 = Employee.create(first_name: 'Marcos', last_name: 'Carrizo', legajo: '3', email: 'mmarcos@m.com', password: '123456')

        record_1 = EmployeeRecord.create(in_employee: '2019-02-01T01:05:00.000Z',
                             out_employee: '2019-02-01T05:05:00.000Z',
                             user_id: employee_1.id,
                             created_at:'2019-02-01')

        record_2 = EmployeeRecord.create(in_employee: '2019-03-01T01:05:00.000Z',
                             user_id: employee_2.id,
                             created_at:'2019-03-01')

        record_3 = EmployeeRecord.create(in_employee: '2019-03-01T01:05:00.000Z',
                             user_id: employee_3.id,
                             created_at:'2019-03-01')

        get "/api/v1/employee_records"

        expect(response.status).to eql 200

        expect(
          json_body[:employee_records].map { |r| r[:id] }
        ).to match_array([record_2.id, record_3.id])
      end
    end
  end

  describe "GET /api/v1/employees/{id}/employee_records" do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    context "get employee records" do
      it "get employee_records of an employee" do
        employee = Employee.create(first_name: 'Miguel', last_name: 'Carrizo', legajo: '1', email: 'miguel@m.com', password: '123456')
        record_1 = EmployeeRecord.create(in_employee: '2019-02-01T01:05:00.000Z',
                             out_employee: '2019-02-01T05:05:00.000Z',
                             user_id: employee.id,
                             created_at:'2019-02-01')

        record_2 = EmployeeRecord.create(in_employee: '2019-02-02T01:05:00.000Z',
                             out_employee: '2019-02-02T05:05:00.000Z',
                             user_id: employee.id,
                             created_at:'2019-02-02')

        record_3 = EmployeeRecord.create(in_employee: '2019-03-01T01:05:00.000Z',
                             user_id: employee.id,
                             created_at:'2019-03-01')

        get "/api/v1/employees/#{employee.id}/employee_records"

        expect(response.status).to eql 200
        expect(
          json_body[:employee_records].map { |r| r[:user_id] }
        ).to match_array([employee.id])
      end
    end
  end

  describe "POST /api/v1/employees/{id}/employee_records" do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }
    let(:now) { Time.parse('2019-02-27T01:05:00.000Z') }
    let(:employee) {Employee.create(first_name: 'Miguel', last_name: 'Carrizo', legajo: '1', email: 'miguel@m.com', password: '123456')}
    
    before do
      Timecop.freeze(now)
    end

    after do
      Timecop.return
      EmployeeRecord.destroy(json_body[:employee_record][:id]) if json_body.dig(:employee_record, :id)
      employee&.destroy
    end

    context 'when employee in' do
      it "create employee record" do
        post "/api/v1/employees/#{employee.id}/employee_records"
        
        expect(response.status).to eql 201
        expect(json_body).to include(
          employee_record: a_hash_including(
            id: a_kind_of(Integer),
            in_employee: '2019-02-27T01:05:00.000Z',
            out_employee: nil,
            user_id: employee.id
          )
        )
      end
    end

    context 'when employee out' do
      let(:out_time) { Time.parse('2019-02-27T08:05:00.000Z') }

      it "updates employee record" do
        post "/api/v1/employees/#{employee.id}/employee_records"
        in_id = JSON.parse(response.body, symbolize_names: true)[:employee_record][:id]
        Timecop.freeze(out_time)
        put "/api/v1/employees/#{employee.id}/employee_records"
        
        expect(response.status).to eql 200
        expect(json_body).to include(
          employee_record: a_hash_including(
            id: in_id,
            in_employee: '2019-02-27T01:05:00.000Z',
            out_employee: out_time,
            user_id: employee.id,
            created_at:'2019-02-27T01:05:00.000Z',
            updated_at: out_time
          )
        )
      end
    end
  end
end
