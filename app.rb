require "sinatra"
require "sinatra/reloader"
require "dotenv/load"

# Pull in the HTTP class
require "http"

# define a route for the homepage
get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")
  @currencies_keys = @currencies.keys

  erb(:homepage)
end

get("/:currency") do
  @currency = params.fetch("currency")
  # api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  
  # # Fetch API data (again)
  # raw_response = HTTP.get(api_url)
  # parsed_data = JSON.parse(raw_response.to_s)

  # currencies = parsed_data.fetch("currencies")
  # currency_key = params[:currency] # Get currency from URL

  erb(:currency)
end
