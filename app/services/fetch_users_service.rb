require 'net/http'
require 'json'

class FetchUsersService
  def self.call
    url = URI.parse('https://jsonplaceholder.typicode.com/users')
    response = Net::HTTP.get_response(url)
    users = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

    users.each do |user_data|
      user = User.find_or_initialize_by(id: user_data['id'])
      user.update(
        name: user_data['name'],
        username: user_data['username'],
        email: user_data['email'],
        phone: user_data['phone'],
        website: user_data['website']
      )
    end

    User.all # Return all users from the database
  end
end
