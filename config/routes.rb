Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :employee_records, only: [:index, :create]
      resources :employees, only: [:index, :create] do
        resources :employee_records, only: [:index] do
          collection do
            put :update
          end
        end
      end
      devise_for :users
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    end
  end
end
