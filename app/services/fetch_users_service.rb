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

  def self.update(user, user_params)
    updated_user_data = update_user(user, user_params)

    updated_user = User.find_by(id: updated_user_data['id'])
    updated_user.update(
      name: updated_user_data['name'],
      username: updated_user_data['username'],
      email: updated_user_data['email'],
      phone: updated_user_data['phone'],
      website: updated_user_data['website']
    )
    updated_user
  end

  def self.destroy(id)
    response = destroy_user(id)
    if response[:status] == 200
      response
    end
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

    def self.update_user(user, user_params)
      # faking the id for the API
      url = URI.parse("#{BASE_URL}/1")
      http = Net::HTTP.new(url.host)
      request = Net::HTTP::Put.new(url.path, {'Content-Type' => 'application/json'})

      request.body = user_params.to_json

      response = http.request(request)

      parsed_response = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

      # returning our user's id
      parsed_response['id'] = user.id

      parsed_response
    end

    def self.destroy_user(id)
      # faking the id for the API
      url = URI.parse("#{BASE_URL}/1")
      http = Net::HTTP.new(url.host)
      request = Net::HTTP::Delete.new(url.path, {'Content-Type' => 'application/json'})

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        { status: 200, message: "Deleted user with id #{id}" }
      else
        { status: response.code.to_i, message: "Failed to delete user with id #{id}" }
      end
    end
end
