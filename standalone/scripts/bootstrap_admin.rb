email = ENV['BOOTSTRAP_ADMIN_EMAIL']
password = ENV['BOOTSTRAP_ADMIN_PASSWORD']
name = ENV['BOOTSTRAP_ADMIN_NAME'] || 'Admin User'

if email.to_s.empty? || password.to_s.empty?
  puts 'Missing BOOTSTRAP_ADMIN_EMAIL or BOOTSTRAP_ADMIN_PASSWORD'
  exit 1
end

first_name, last_name = name.split(' ', 2)
first_name ||= 'Admin'
last_name ||= 'User'

user = User.find_or_initialize_by(email: email)
user.first_name = first_name
user.last_name = last_name
user.password = password
user.password_confirmation = password
user.role = 'admin' if user.respond_to?(:role=)
user.confirmed_at = Time.now if user.respond_to?(:confirmed_at=)
user.account_id ||= (Account.first&.id || Account.create!(name: 'Default').id)
user.save!

puts "bootstrap_admin_ok id=#{user.id} email=#{user.email}"

