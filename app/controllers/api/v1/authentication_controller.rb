module Api
  module V1
    class AuthenticationController < Api::V1::BaseController
      skip_before_action :authorize_request
      # POST auth/login
      # return auth token once user is authenticated
      def authenticate
        auth_token =
          Auth::AuthenticateUser.new(auth_params[:email],
                                     auth_params[:password]).call
        json_response(auth_token: auth_token)
      end

      private

      def auth_params
        params.permit(:email, :password)
      end
    end
  end
end
