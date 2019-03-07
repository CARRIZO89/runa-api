class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController
  # POST /resource/sign_in
  def create
    super do
       render json: { user: current_api_v1_user, type_user: current_api_v1_user.type
                    }.to_json and return
    end
  end
end
