module UsersHelper
  class Hash
    def self.encrypt(password)
      BCrypt::Password.create(password)
    end

    def self.valid?(password, encrypted)
      my_password = BCrypt::Password.new(encrypted)
      my_password == password
    rescue StandardError
      false
    end
  end

  class Validator
    def self.valid_app_token?(header)
      return [false, 'Invalid token', :unauthorized] unless header

      token = header.split.last
      name = JwtHelper::JsonWebToken.decode(token)
      return [false, 'Unauthorized app', :forbidden] if App.where(name:, token:).empty?

      true
    end

    def self.valid_credentials?(email, password)
      user = User.find_by_email(email)
      return [false, 'email already taken', :unauthorized] if user

      return [false, 'password too short', :bad_request] if password.size < 6

      true
    end

    def self.valid_user_token?(header)
      return [false, 'Invalid token', :unauthorized] unless header

      token = header.split.last
      email = JwtHelper::JsonWebToken.decode(token)
      return [false, 'Unauthorized user', :forbidden] if User.where(email:, token:).empty?

      return [true, 'User ok', :ok, User.find_by_email(email)]

    end
  end
end
