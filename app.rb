require 'rubygems'
require 'httparty'
require 'sinatra/base'
require 'dotenv/load'
require 'thin'
require 'json'

# class App < Sinatra::Application

  class APIRequest
    # include HTTParty

    def users(page_number, per_page)
      response = HTTParty.get("https://driftrock-dev-test-2.herokuapp.com/users",
      :query => {:page => page_number, :per_page => per_page})
      response.body
    end

    def purchases(page_number, per_page)
      response = HTTParty.get("https://driftrock-dev-test-2.herokuapp.com/purchases",
      :query => {:page => page_number, :per_page => per_page})
      response.body
    end


  end

#   api_request = APIRequest.new
#
#   get '/users' do
#     api_request.users(3)
#   end
#
#   get '/purchases' do
#     api_request.purchases(1)
#   end
#
#   run! if app_file == $0
#
# end
