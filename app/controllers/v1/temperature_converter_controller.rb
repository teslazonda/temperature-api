module V1
  class TemperatureConverterController < ApplicationController
    MAX_DECIMAL_PLACES = 10
    SUN_CORE_TEMPERATURE_CELSIUS = 15_000_000.0
    SUN_CORE_TEMPERATURE_FAHRENHEIT = 27_000_000.0

    def convert
      temperature = params[:temperature].to_f
      unit = params[:unit].to_s.downcase

      validate_temperature_precision(temperature)

      case unit
      when 'celsius'
        raise ArgumentError, "Temperature exceeds upper limit of #{SUN_CORE_TEMPERATURE_CELSIUS} Celsius - That's hotter than the center of the sun!" if temperature > SUN_CORE_TEMPERATURE_CELSIUS
        raise ArgumentError, 'Temperature below absolute zero is not possible' if temperature < -273.15

        fahrenheit = ((temperature * 9/5) + 32).round(MAX_DECIMAL_PLACES)
        render json: { temperature: temperature.round(MAX_DECIMAL_PLACES), unit: 'Celsius', converted_temperature: fahrenheit, converted_unit: 'Fahrenheit' }
      when 'fahrenheit'
        raise ArgumentError, "Temperature exceeds upper limit of #{SUN_CORE_TEMPERATURE_FAHRENHEIT} Fahrenheit - That's hotter than the center of the sun!" if temperature > SUN_CORE_TEMPERATURE_FAHRENHEIT
        raise ArgumentError, 'Temperature below absolute zero is not possible' if temperature < -459.67

        celsius = ((temperature - 32) * 5/9).round(MAX_DECIMAL_PLACES)
        render json: { temperature: temperature.round(MAX_DECIMAL_PLACES), unit: 'Fahrenheit', converted_temperature: celsius, converted_unit: 'Celsius' }
      else
        render json: { error: 'Invalid unit. Please provide either "Celsius" or "Fahrenheit".' }, status: :unprocessable_entity
      end
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: "An error occurred: #{e.message}" }, status: :unprocessable_entity
    end

    private

    def validate_temperature_precision(temperature)
      raise ArgumentError, "Temperature must have fewer than or equal to #{MAX_DECIMAL_PLACES} decimal places" if temperature.to_s =~ /\.(\d{#{MAX_DECIMAL_PLACES + 1},})$/
    end
  end
end
