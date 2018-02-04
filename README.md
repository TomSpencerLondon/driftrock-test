# Driftrock API

## The brief
The task was to create a script to interact with a custom-made Driftrock API that could be run from the command line. The script would accept one parameter in the command line to specify which question it would answer and one of the questions included a parameter. The commands were as follows: 
```
most_sold: What was the name of the most sold item? 
total_spend [EMAIL]: What is the total spend of the user with this email address [EMAIL]? 
most_loyal: What is the email address of the most loyal user (most purchases)? 
```
The application would be run in the command line in the following way: 
```
ruby app.rb COMMAND PARAMETERS 
```

## My Approach:

I felt that using the Driftrock API was an excellent opportunity to hone my skills at using APIs and this is a skill that I consider very important. 

The Apiary interactive documentation (https://driftrockdevtest.docs.apiary.io/#)  provided an interactive representation of the test API which allowed me to interact with the API even before I had built it so I was able to get immediate visibility on the API without using Postman. 

The test involved working out how best to merge data returned from two different end points. The JSON API on https://driftrock-dev-test.herokuapp.com included an endpoint for user data (/users) and another for purchases (/purchases) data. Both the endpoints were paginated (?per_page=100&page=1) but there was no meta information to query to ask for the total number of pages or entries. The only way to know if I had reached the end of the JSON API was that the number of entries returned on the final page would be less than the amount requested per page. 

The User data looked like this: 
```
{ "data": [ 
{ "id": "12DF-2324-GA2D-31RT", "first_name": "Drift", "last_name": "Rock", "phone": "0-200-100-1234", "email": "drift.rock@email.com" 
}, ... ] 
} 
The purchases data looked like this: 
{ "data": [ 
{ "user_id": "12DF-2324-GA2D-31RT", "item": "Huge pineapple pizza", "spend": "19.99" 
}, { 
} ] 
} 
```
I used HTTParty in order to interact with the JSON API. This is a fun gem, which allows the user to add queries efficiently as part of the get request. Since I had easily implemented the get request I now aimed to get visibility by creating an instance of the APIRequest class in my find_email method and then iterate through this JSON API to return the correct email from a requested id. I used an until loop in order to iterate through the users endpoint incrementing the page number and checking the array length against the per_page parameter to verify whether we had reached the end of the JSON API.  

```
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
```

The problem with this solution was that it was inefficient, repetitive and a time consuming way of querying the API. It was inefficient because it involved calling the API fully before separately iterating through the array in order to check for the correct ‘id’. It was repetitive because I would have to use this code in each of the methods in order to call the different endpoints and extract the required information and it was time consuming because iterating through the entire array twice and then checking through the returned result would leave the user waiting for up to a minute for the correct answer which would affect user experience. 
After some thought and research I discovered a useful means of rationalizing the API requests into a separate method:
``` 
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
```

The in-built ruby Enumerator class allowed me to perform a similar action to the earlier until loop however this time I would be able to combine the API request with the action of searching through the returned array by implementing the internal iterator with yield. 
I then called the APIRequest class in my methods using a proc so that I could put the class method in as a parameter to the methods as necessary: 
```
def find_email(requested_id)
  api_request_proc = Proc.new{ |page_number, per_page| APIRequest.users(page_number, per_page) }

  enum = APIRequest.api_request_enumerator(api_request_proc)
  enum.each do |hash|
    return hash['email'] if hash['id'] == requested_id
  end
end
```

The final challenge was to work out how to implement the methods from the command line. I used the ARGV array for capturing the command line arguments as outlined in the test specifications: 
```
  if ARGV[0] == "most_sold"
  puts most_sold
elsif ARGV[0] == "total_spend"
  puts total_spend(ARGV[1])
elsif ARGV[0] == "most_loyal"
  puts most_loyal
end 
```

My if and else statements took account of each possible command request. 


## Using the application

This is a command line application so it is necessary to clone the file in order to run it:
```
$ git clone https
$ cd drifrock-test
$ run app.rb with the required method: ‘ruby app.rb most_sold’ OR ‘ruby app.rb total_spend(“purdy_elva@bahringer.net”) OR ‘ruby app.rb most_loyal’
```
## If I had more time...I would include:
* Effective testing for API calls 
* Cleaner design of app.rb and more separation of concerns 
* Work on improving the design of my code by further reducing repetition. 
* Further efficiency savings on calling the API


