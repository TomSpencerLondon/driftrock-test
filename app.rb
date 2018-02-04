require_relative 'api'
require 'json'


class App 

  def find_email(requested_id)
    api_request_proc = Proc.new{ |page_number, per_page| APIRequest.users(page_number, per_page) }

    enum = APIRequest.api_request_enumerator(api_request_proc)
    enum.each do |hash|
      return hash['email'] if hash['id'] == requested_id
    end
  end

  def find_id(requested_email)
    api_request_proc = Proc.new{ |page_number, per_page| APIRequest.users(page_number, per_page) }

    enum = APIRequest.api_request_enumerator(api_request_proc)
    enum.each do |hash|
      return hash['id'] if hash['email'] == requested_email
    end
  end

  def total_sales_of_each_product
    output = Hash.new(0)
    api_request_proc = Proc.new{ |page_number, per_page| APIRequest.purchases(page_number, per_page) }

    enum = APIRequest.api_request_enumerator(api_request_proc)
    enum.each do |hash|
      output[hash['item']] += 1
    end
    output
  end

  def most_sold
    (total_sales_of_each_product.max_by { |k, v| v })[0]
  end



  def total_spend(email_address)
    user_id = find_id(email_address)
    total_spend = 0
    api_request_proc = Proc.new{ |page_number, per_page| APIRequest.purchases(page_number, per_page) }

    enum = APIRequest.api_request_enumerator(api_request_proc)
    enum.each do |hash|
      total_spend += hash['spend'].to_i if hash['user_id'] == user_id
    end
    "£%.2f" % total_spend
  end

  def total_orders_by_each_user
    output = Hash.new(0)
    api_request_proc = Proc.new{ |page_number, per_page| APIRequest.purchases(page_number, per_page) }
    enum = APIRequest.api_request_enumerator(api_request_proc)
    enum.each do |hash|
      output[hash['user_id']] += 1
    end
    output
  end

  def most_loyal
    user_id = (total_orders_by_each_user.max_by { |k, v| v })[0]
    find_email(user_id)
  end

end 

app = App.new

if ARGV[0] == "most_sold"
  puts app.most_sold
elsif ARGV[0] == "total_spend"
  puts app.total_spend(ARGV[1])
elsif ARGV[0] == "most_loyal"
  puts app.most_loyal
end 