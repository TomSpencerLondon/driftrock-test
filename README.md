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

## Using the application

This is a command line application so it is necessary to clone the file in order to run it:
```
$ git clone https
$ cd drifrock-test
$ cd lib
$ run app.rb with the required method: ‘ruby app.rb most_sold’ OR ‘ruby app.rb total_spend purdy_elva@bahringer.net' OR ‘ruby app.rb most_loyal’
```
## If I had more time...I would include:
* Effective testing for API calls 
* Cleaner design of app.rb and more separation of concerns 
* Work on improving the design of my code by further reducing repetition. 
* Further efficiency savings on calling the API


