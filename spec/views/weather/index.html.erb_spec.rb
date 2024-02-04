# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'weather/index', type: :view do
  context 'when data was successfully retrieved' do
    let(:data) { OpenWeather::Models::City::Weather.new }
    let(:main) { OpenWeather::Models::Main.new }
    let(:weather) { OpenWeather::Models::Weather.new }

    before(:each) do
      main.temp = 73
      main.temp_max = 85
      main.temp_min = 65
      main.humidity = 66
      main.feels_like = 75

      data.name = 'Cupertino'
      data.main = main
      data.weather = [weather]

      assign(:cache, true)
      assign(:zipcode, '95014')
      assign(:data, data)
    end

    it 'renders the conditions' do
      render
      expect(rendered).to have_selector('tr>th', text: 'Current:')
      expect(rendered).to have_selector('tr>th', text: 'Real Feel:')
      expect(rendered).to have_selector('tr>th', text: 'Min Temp:')
      expect(rendered).to have_selector('tr>th', text: 'Max Temp:')
      expect(rendered).to have_selector('tr>th', text: 'Humidity:')
    end
  end

  context 'when data was not successfully retrieved' do
    before(:each) do
      assign(:data, nil)
    end

    it 'renders an error message' do
      render
      expect(rendered).to have_selector('div', text: 'There was an issue obtaining the weather for zipcode!')
    end
  end
end
