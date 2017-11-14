require 'httparty'

class Kele
    include HTTParty
    
    def initialize(email, password)
        @options = { body: { "email": email, "password": password } }
        response = self.class.post("https://www.bloc.io/api/v1/sessions", @options)
        raise "invalid email or password" if response.code == 401
        @auth_token = response["auth_token"]
    end
end