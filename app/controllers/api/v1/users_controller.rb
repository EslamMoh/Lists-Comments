module Api
  module V1
    class UsersController < Api::V1::BaseController
      skip_before_action :authorize_request, only: :create
      skip_load_and_authorize_resource only: %i[create show]
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

      # GET /user
      # get current user data
      def show
        json_response(current_user.decorate, :ok)
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
