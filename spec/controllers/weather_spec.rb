# frozen_string_literal: true

require 'rails_helper'
require 'vcr_setup'

RSpec.describe WeatherController, type: :controller do
  context 'weather#index', :vcr do
    context 'when called with no parameters' do
      subject { get :index }

      it 'defaults zipcode to Cupertino, CA' do
        subject
        expect(assigns(:zipcode)).to be '95014'
      end

      it 'sets the cache variable' do
        subject
        expect(assigns(:cache)).not_to be_nil
      end

      it 'returns the weather for Cupertino, CA' do
        subject

        data = assigns(:data)
        expect(data).to be_kind_of(Hash)
        expect(data.name).to eql 'Cupertino'
      end
    end

    context 'when called with a valid zipcode' do
      subject { get :index, params: { zipcode: zipcode } }

      let(:zipcode) { '22102' }

      it 'sets the zipcode to the parameter' do
        subject
        expect(assigns(:zipcode)).to eql zipcode
      end

      it 'sets the cache variable' do
        subject
        expect(assigns(:cache)).not_to be_nil
      end
    end

    context 'when called with an invalid zipcode' do
      subject { get :index, params: { zipcode: zipcode } }

      let(:zipcode) { '00000' }

      it 'sets the data to nil' do
        subject
        expect(assigns(:data)).to be_nil
      end
    end

    context 'when called with an invalid API key set' do
      it 'sets the data to nil' do
        # Save the API key so that we can restore it for other tests
        previous_apikey = ENV['OPENWEATHER_APIKEY']

        # Set the API key to something invalid
        ENV['OPENWEATHER_APIKEY'] = 'this is not valid'

        subject
        expect(assigns(:data)).to be_nil

        # Restore the API key
        ENV['OPENWEATHER_APIKEY'] = previous_apikey
      end
    end

    context 'when caching is available' do
      subject { get :index }

      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      context 'when called the first time' do
        it 'does not find the value in the cache' do
          expect(Rails.cache.exist?("zipcode_#{assigns(:zipcode)}")).to be_falsey
          subject
          expect(assigns(:cache)).to be_falsey
          expect(Rails.cache.exist?("zipcode_#{assigns(:zipcode)}")).to be_truthy
        end
      end

      context 'when called multiple times' do
        it 'finds the zipcode in the cache after the second request' do
          get :index
          expect(assigns(:cache)).to be_falsey

          get :index
          expect(assigns(:cache)).to be_truthy
        end
      end
    end
  end
end
