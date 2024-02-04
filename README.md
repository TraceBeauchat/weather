# README

Weather is a simple Ruby/Rails application that provides the current weather
for a provided zipcode.  When no zipcode parameter is provided the zipcode
defaults to 95014 (Cupertino, CA).

This application obtains the current weather using the 
[OpenWeather API](https://openweathermap.org).  

## Configuration

An API key is required and is pulled from the _OPENWEATHER_APIKEY_ environment variable.  An
API key can be generated going to [OpenWeather.org](https://openweathermap.org) and
creating an account.  Please refer to your particular environment on
how to create an environment variable for your key.  For example, when
using BASH shell you can edit your _.bashrc_ and add the following line:

```
export OPENWEATHER_APIKEY="<api-key>"
```

## Gems

The following additional Gems are required by the server:

* [open-weather-ruby-client](https://github.com/dblock/open-weather-ruby-client/tree/master?tab=readme-ov-file)
* [sass-rails](https://github.com/rails/sass-rails)

## Test Suite

The test suite is written [RSpec](https://github.com/rspec/rspec-rails) and 
uses [simplecov](https://github.com/simplecov-ruby/simplecov) to calculate code
coverage.

Additionally, because this application makes use of a third-party API, the test suite 
uses [VCR](https://github.com/vcr/vcr) to record the API interactions.  The recorded 
_cassettes_ can be found under spec/cassettes within the source repository.