class UsersController < ApplicationController
  def index
    @users = FetchUsersService.call
  end
end
