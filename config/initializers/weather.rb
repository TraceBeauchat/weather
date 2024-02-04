# frozen_string_literal: true

# Initialize the OpenWeather client at start-up
Rails.application.config.weather = OpenWeather::Client.new(
  api_key: ENV['OPENWEATHER_APIKEY']
)
