module AuthHelper
  def auth_header
    admin = User.create(email: 'admin_test@example.com', password: 'asdqwe123', password_confirmation: 'asdqwe123', type: 'Admin')
    admin.confirm
    admin.create_new_auth_token
  end
end
