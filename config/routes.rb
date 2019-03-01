Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :employee_records, only: [:index]
      resources :employees, only: [:index, :create, :update] do
        resources :employee_records, only: [:index, :create] do
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
