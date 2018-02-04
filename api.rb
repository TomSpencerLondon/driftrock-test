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

  def self.api_request_enumerator(api_request_proc, per_page = 2000)
    page_number = 1
    reached_end = false
  
    Enumerator.new do |enum|
      until reached_end
        object = JSON.parse(api_request_proc.call(page_number, per_page))
        array = object['data']
  
        array.each do |hash|
          enum.yield(hash)
        end
        page_number += 1
        reached_end = array.length < per_page
      end
    end
  
  end

end

