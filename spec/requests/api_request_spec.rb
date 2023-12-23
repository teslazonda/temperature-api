require 'rails_helper'

RSpec.describe 'API Requests', type: :request do
  describe 'Temperature Input' do
    it 'returns the correct conversion for 0 degrees Celsius' do
      post 'http://localhost:3000/v1/convert_temperature', params: '{ "temperature": 0, "unit": "Celsius" }', headers: { 'Content-Type': 'application/json' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('{"temperature":0.0,"unit":"Celsius","converted_temperature":32.0,"converted_unit":"Fahrenheit"}')
    end

    it 'returns the correct conversion for 0 degrees Fahrenheit' do
      post 'http://localhost:3000/v1/convert_temperature', params: '{ "temperature": 0, "unit": "Fahrenheit" }', headers: { 'Content-Type': 'application/json' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('{"temperature":0.0,"unit":"Fahrenheit","converted_temperature":-17.7777777778,"converted_unit":"Celsius"}')
    end
  end

  describe 'Temperature Input absolute zero' do
    it 'returns a 422 response for temperatures below absolute zero' do
      post 'http://localhost:3000/v1/convert_temperature', params: '{ "temperature": -300, "unit":  "Celsius" }', headers: { 'Content-Type':  'application/json' }
      expect(response).to have_http_status(422)
      expect(json_response['error']).to eq('Temperature below absolute zero is not possible')
    end
  end
  describe 'Invalid Temperature Input' do
    it 'returns an unprocessable_entity response for invalid temperatures' do
      post 'http://localhost:3000/v1/convert_temperature', params: '{ "temperature": asdf, "unit":  "Celsius" }', headers: { 'Content-Type':  'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Error occurred while parsing request parameters")
    end
  end


  # Helper method to parse JSON response
  def json_response
    JSON.parse(response.body)
  end
end
