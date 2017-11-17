require 'httparty'
require 'json'
require './lib/roadmap.rb'
require 'rest_client'
require 'rubygems'

class Kele
    include HTTParty
    include Roadmap
    
    def initialize(email, password)
        @options = { body: { "email": email, "password": password } }
        response = self.class.post("https://www.bloc.io/api/v1/sessions", @options)
        raise "invalid email or password" if response.code == 401
        @auth_token = response["auth_token"]
    end
    
    def get_me
        response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
        JSON.parse(response.body)
    end
    
    def get_mentor_availability(mentor_id)
        response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
        JSON.parse(response.body)
    end
    
    def get_messages(*page)
        page_string = page.to_s
        response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token }, values: {"page": page_string})
        JSON.parse(response.body)
    end
    
    def create_message(email, recipient_id, subject, stripped_text)
        response = self.class.post("https://www.bloc.io/api/v1/messages", headers: { "authorization" => @auth_token }, body: {
            "sender": email, 
            "recipient_id": recipient_id,
            "subject": subject,
            "stripped-text": stripped_text
        })
        response.success? puts "Message Sent"
    end
    
end