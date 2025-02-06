require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"

# Fetch the currencies once and store in a global variable
api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
raw_response = HTTP.get(api_url)
parsed_data = JSON.parse(raw_response.to_s)

# Store globally so it is available in all routes
$currencies = parsed_data.fetch("currencies")
$currencies_keys = $currencies.keys

# Homepage route
get("/") do
  @currencies_keys = $currencies_keys # Assign global data to instance variable
  erb(:homepage)
end

# Route for a specific currency
get("/:currency") do
  @currency = params.fetch("currency")
  @currencies_keys = $currencies_keys # Assign global data
  erb(:currency)
end

get("/:currency/:foreign_currency") do
  @currency = params.fetch("currency")
  @foreign_currency = params.fetch("foreign_currency")
  api_url_converted = "https://api.exchangerate.host/convert?from=#{@currency}&to=#{@foreign_currency}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  raw_response_converted = HTTP.get(api_url_converted)
  parsed_converted_data = JSON.parse(raw_response_converted)
  
  @result = parsed_converted_data.fetch("result")

  erb(:conversion)
end
