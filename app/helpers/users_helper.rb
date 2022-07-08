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
end
