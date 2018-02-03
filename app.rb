require 'rubygems'
require 'httparty'
require 'sinatra/base'
require 'dotenv/load'
require 'thin'
require 'json'


class APIRequest

  def self.users(page_number, per_page)
    response = HTTParty.get("https://driftrock-dev-test-2.herokuapp.com/users",
    :query => {:page => page_number, :per_page => per_page})
    response.body
  end

  def self.purchases(page_number, per_page)
    response = HTTParty.get("https://driftrock-dev-test-2.herokuapp.com/purchases",
    :query => {:page => page_number, :per_page => per_page})
    response.body
  end


end
