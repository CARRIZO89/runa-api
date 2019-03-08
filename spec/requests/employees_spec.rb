require 'rails_helper'

RSpec.describe "Employees", type: :request do
  describe "Manage employee" do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it "create an employee" do
      post '/api/v1/employees', params: {
        employee: {first_name: 'Miguel', last_name: 'Carrizo', legajo: '1', email: 'miguel_1@m.com', password: '123456'}
      }, headers: auth_header

      expect(response.status).to eql 201
      expect(json_body).to include(
        employee: a_hash_including(
          id: a_kind_of(Integer),
          first_name: "Miguel",
          last_name: "Carrizo",
          email: "miguel_1@m.com",
          legajo: 1,
        )
      )
    end

    it "update an employee" do
      employee = Employee.create(first_name: 'Maria', last_name: 'Carrizo', legajo: '2', email: 'maria@m.com', password: '123456')

      put "/api/v1/employees/#{employee.id}", params: {
        employee: { first_name: 'Maria Emilia' }
      }, headers: auth_header

      expect(response.status).to eql 200
      expect(json_body).to include(
        employee: a_hash_including(
          id: employee.id,
          first_name: "Maria Emilia",
          last_name: "Carrizo",
          email: "maria@m.com",
          legajo: 2,
        ))
    end

    after { Employee.find(json_body[:employee][:id]).destroy if json_body.dig(:employee, :id) }
  end
end
