# README

Welcome to teslazonda's temperature API. This API takes a temperature as input and converts the input to another unit. Both Fahrenheit -> Celsius and Celsius -> Fahrenheit conversions are possible.

## Dependencies

* [Ruby](https://www.ruby-lang.org/en/downloads/) 3.2.2
* [Rails](https://guides.rubyonrails.org/v5.0/getting_started.html#installing-rails) 7.0.8

## Setup

* Navigate to the project directory
* Run `bundle install` to install Ruby gems.
* Run `rails s` in the project directory to start the server


## Requests and Responses
The Rails application will run by default on port 3000. The following URL can be used to test the application locally: `http://localhost:3000/v1/convert_temperature`
### POST v1/convert_temperature

#### Headers

```
 -H 'Content-Type: application/json'
```

#### Request Body

```
{
  "temperature: float,
  "unit": "string"
}

```
Note: The unit must either be "Celsius" or "Fahrenheit".

#### Status 200
Successful `curl` request
```bash
curl -X POST -H "Content-Type: application/json" -d '{"temperature": 100, "unit": "Celsius"}' http://localhost:3000/v1/convert_temperature
```

Sample response

```bash
{"temperature":100.0,"unit":"Celsius","converted_temperature":212.0,"converted_unit":"Fahrenheit"}
```


#### Status 422
Input temperature is less than absolute zero

```bash
curl -X POST -H "Content-Type: application/json" -d '{"temperature": -300, "unit": "Celsius"}' http://localhost:3000/v1/convert_temperature
```

Sample response
```bash
{"error":"Temperature below absolute zero is not possible"}
```
#### Status 400
Bad Request

```bash
curl -X POST -H "Content-Type: application/json" -d '{"Bad Request"}' http://localhost:3000/v1/convert_temperature
```

Sample response
```bash
{"error":"An error occurred: Error occurred while parsing request parameters"}
```

## Tests
* Run `bundle exec rspec` to run unit tests
