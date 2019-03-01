require 'rails_helper'

RSpec.describe "Employees", type: :request do
  describe "POST api/v1/employees" do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'creates an employee' do
      post '/api/v1/employees', params: { 
        employee: { first_name: 'Miguel', last_name: 'Carrizo', legajo: '1', email: 'miguel@m.com', password: '123456'}
      }

      expect(response.status).to eql 201
      expect(json_body).to include(
        employee: a_hash_including(
          email: "miguel@m.com",
          first_name: "Miguel",
          id: a_kind_of(Integer),
          last_name: "Carrizo",
          legajo: 1,
        )
      )
    end

    after { Employee.find(json_body[:employee][:id]).destroy if json_body.dig(:employee, :id) }
  end
end
