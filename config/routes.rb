Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'users', controllers: { sessions: 'api/v1/users/sessions' }
      resources :employee_records, only: [:index, :update]
      resources :employees, only: [:index, :create, :update] do
        resources :employee_records, only: [:index, :create], controller: 'employees/employee_records' do
          collection do
            put :update
            get :last, to: "last_employee_records#show"
          end
        end
      end
    end
  end
end
