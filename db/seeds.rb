puts "Creating an User"
User.create(email: 'admin@example.com', password: 'admin123', password_confirmation: 'admin123', type: 'Admin')
