module Api
  module V1
    class UsersController < Api::V1::BaseController
      skip_before_action :authorize_request, only: :create

      # GET /users
      # get list of users
      def index
        users = User.all
        authorize users
        json_response(PageDecorator.decorate(users), :ok)
      end

      # GET /user
      # get current user data
      def show
        authorize User
        json_response(current_user.decorate, :ok)
      end

      # POST /signup
      # return authenticated token upon signup
      def create
        user = User.create!(user_params)
        auth_token = Auth::AuthenticateUser.new(user.email,
                                                user.password).call
        response = { message: Message.account_created,
                     auth_token: auth_token }
        json_response(response, :created)
      end

      private

      def user_params
        params.permit(
          :name,
          :email,
          :role,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
