![Ruby CI](https://github.com/Wizyma/ruby-test/workflows/Ruby%20CI/badge.svg)

# Instructions for applicant

## Description

We have an existing application that provides an api to execute a payment between two registered users.  
Since we are dealing with "ticket restaurant", 2 laws applies:
* payment amount must be equal or inferior to 19 euros
* payment should only occurs during worked days

The current implementation works well in production.  
The code is in files "app/models/user.rb" and "app/controllers/payments_controller.rb".  
We have few support tickets signifying that the code might contains minor bugs.  

You can test the feature in local with these commands:
```shell script
rails server &
rails runner '%w(123 456).each { |id| User.create!(id: id, email: "#{id}_mail@test.com") }'
curl -X POST http://127.0.0.1:3000/payments -H "Content-Type: application/json" --data '{"emitter_id":"123","receiver_id":"456","amount":140}'
```

## Step 1: Bug correction

We forget about the public holidays!  
They are to be treated as weekend: you cannot use your "ticket restaurant".  


## Step 2: New feature

The government passed a new law, authorizing usage of "ticket restaurant" every day, and with a limit doubled,
but only in restaurants, and not in other food stores (like supermarkets).  
Supermarkets keep the same existing limits.  
You are asked to implement this new feature.  


## Hints

You are free to correct existing bugs, but your primary goal is the new feature.  
Please note your start / stop times for both steps.  
You can ask questions.  

245 678
