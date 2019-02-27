require 'rails_helper'

RSpec.describe "EmployeeRecords", type: :request do
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

      before do
        Timecop.travel(out_time)
      end

      after do
        Timecop.return
      end

      it "updates employee record" do
        post "/api/v1/employees/#{employee.id}/employee_records"
        in_id = JSON.parse(response.body, symbolize_names: true)[:employee_record][:id]

        put "/api/v1/employees/#{employee.id}/employee_records"
        
        expect(response.status).to eql 200
        expect(json_body).to include(
          employee_record: a_hash_including(
            id: in_id,
            in_employee: '2019-02-27T01:05:00.000Z',
            out_employee: '2019-02-27T08:05:00.000Z',
            user_id: employee.id,
            created_at:'2019-02-27T01:05:00.000Z',
            updated_at: '2019-02-27T08:05:00.000Z'
          )
        )
      end
    end
  end
end
