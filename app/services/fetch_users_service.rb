require 'net/http'
require 'json'

class FetchUsersService
  BASE_URL = 'https://jsonplaceholder.typicode.com/users'

  def self.call
    users = fetch_users

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

    User.all
  end

  def self.create(user_params)
    user_data = create_user(user_params)
    User.create(
      name: user_data['name'],
      username: user_data['username'],
      email: user_data['email'],
      phone: user_data['phone'],
      website: user_data['website']
    )
  end

  private
    def self.fetch_users
      url = URI.parse(BASE_URL)
      response = Net::HTTP.get_response(url)
      JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def self.create_user(user_params)
      url = URI.parse(BASE_URL)
      http = Net::HTTP.new(url.host)
      request = Net::HTTP::Post.new(url.path, {'Content-Type' => 'application/json'})
      request.body = user_params.to_json

      response = http.request(request)

      JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end
end
