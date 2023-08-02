class TokenService
    SECRET_KEY = Rails.application.credentials.secret_key_base
  
    def self.encode(payload)
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      decoded_token = JWT.decode(token, SECRET_KEY).first
      HashWithIndifferentAccess.new(decoded_token)
    rescue JWT::DecodeError
      nil
    end
  end
  