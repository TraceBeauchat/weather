# frozen_string_literal: true

# WeatherController is the sole controller in the weather application.  It provides the
# root path ('/')
class WeatherController < ApplicationController
  # Root path handler.  When request occurs it attempts to fetch the weather for the specified
  # zipcode (defaults to Cupertino, CA) using the OpenWeather API.
  def index
    # Grab the zipcode from the parameters and default to Cupertino, CA if none is provided
    @zipcode = params.permit(:zipcode, :commit)[:zipcode] || '95014'

    # Does the current zipcode exist in the cache?  This value is used to display
    # an indicator on the page if the weather was pulled from the cache.
    @cache = Rails.cache.exist?("zipcode_#{@zipcode}")

    # Retrieve the weather data either from the cache (if the zipcode key exists) or from OpenWeather
    @data = Rails.cache.fetch("zipcode_#{@zipcode}", expires_in: 30.minutes) do
      Rails.application.config.weather.current_weather(zip: @zipcode, country: 'US', units: 'imperial')
    rescue Faraday::ResourceNotFound, OpenWeather::Errors::Fault => e
      Rails.logger.error(e.message)
      nil
    end
  end
end
