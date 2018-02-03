require_relative 'app'
require 'json'

def api_request_enumerator(api_request_proc, per_page = 2000)
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

def find_email(requested_id)
  api_request_proc = Proc.new{ |page_number, per_page| APIRequest.users(page_number, per_page) }

  enum = api_request_enumerator(api_request_proc)
  enum.each do |hash|
    return hash['email'] if hash['id'] == requested_id
  end
end

user_email = find_email("2K7H-A8SQ-6R5V-8OT5")
p user_email

def find_id(requested_email)
  api_request_proc = Proc.new{ |page_number, per_page| APIRequest.users(page_number, per_page) }

  enum = api_request_enumerator(api_request_proc)
  enum.each do |hash|
    return hash['id'] if hash['email'] == requested_email
  end
end

user_id = find_id("purdy_elva@bahringer.net")

p user_id


def total_sales_of_each_product
  output = Hash.new(0)
  api_request_proc = Proc.new{ |page_number, per_page| APIRequest.purchases(page_number, per_page) }

  enum = api_request_enumerator(api_request_proc)
  enum.each do |hash|
    output[hash['item']] += 1
  end
  output
end

def product_with_most_sales
  (total_sales_of_each_product.max_by { |k, v| v })[0]
end

p product_with_most_sales
