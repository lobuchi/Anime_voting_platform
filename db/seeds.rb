user = User.find_or_create_by!(email_address: "admin@anime.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.admin = true
end

puts "Admin User created: admin@anime.com / password"
