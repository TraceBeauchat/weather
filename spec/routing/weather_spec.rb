# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather', type: :routing do
  it 'routes / to WeatherController#index' do
    expect(get('/')).to route_to(
      controller: 'weather',
      action: 'index'
    )
  end
end
