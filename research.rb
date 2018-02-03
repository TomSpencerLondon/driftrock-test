require_relative 'app'
require 'json'

def find_email(requested_id)
  api_request = APIRequest.new

  page_number = 1
  per_page = 20
  reached_end = false

  until reached_end
    object = JSON.parse(api_request.users(page_number, per_page))
    array = object['data']

    array.each do |hash|
      return hash['email'] if hash['id'] == requested_id
    end
    page_number += 1
    reached_end = array.length < per_page
  end

end

user_email = find_email("2K7H-A8SQ-6R5V-8OT5")
p user_email
