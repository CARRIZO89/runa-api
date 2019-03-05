class Api::V1::BaseApiController < ApplicationController
  #include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_api_v1_user!
end
