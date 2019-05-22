class JsonWebToken
  class << self
    # secret to encode and decode token
    APP_SECRET = Rails.application.secrets.secret_key_base

    def encode(payload, exp = 24.hours.from_now)
      # set expiry to 24 hours from creation time
      payload[:exp] = exp.to_i
      # sign token with application secret
      JWT.encode(payload, APP_SECRET)
    end

    def decode(token)
      # get payload; first index in decoded Array
      body = JWT.decode(token, APP_SECRET)[0]
      HashWithIndifferentAccess.new body
      # rescue from all decode errors
    rescue JWT::DecodeError => e
      # raise custom error to be handled by custom handler
      raise ExceptionHandler::InvalidToken, e.message
    end
  end
end
