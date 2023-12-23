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

        converted_temperature = ((temperature * 9/5) + 32).round(MAX_DECIMAL_PLACES)
        render_success(temperature, 'Celsius', converted_temperature, 'Fahrenheit')
      when 'fahrenheit'
        raise ArgumentError, "Temperature exceeds upper limit of #{SUN_CORE_TEMPERATURE_FAHRENHEIT} Fahrenheit - That's hotter than the center of the sun!" if temperature > SUN_CORE_TEMPERATURE_FAHRENHEIT
        raise ArgumentError, 'Temperature below absolute zero is not possible' if temperature < -459.67

        converted_temperature = ((temperature - 32) * 5/9).round(MAX_DECIMAL_PLACES)
        render_success(temperature, 'Fahrenheit', converted_temperature, 'Celsius')
      else
        render_error('Invalid unit. Please provide either "Celsius" or "Fahrenheit".', :unprocessable_entity)
      end
    rescue ArgumentError => e
      #puts "Debug - Error: #{e.message}, Status: #{response.status}" # Debug output
      render_error(e.message, 422)
    rescue StandardError => e
      #puts "Debug - Error: #{e.message}, Status: #{response.status}" # Debug output
      render_error("An error occurred: #{e.message}", :unprocessable_entity)
    end

    private

    def render_success(temperature, unit, converted_temperature, converted_unit)
      render json: { 'temperature': temperature.round(MAX_DECIMAL_PLACES), 'unit': unit, 'converted_temperature': converted_temperature, 'converted_unit': converted_unit }, status: :ok
    end

    def render_error(error_message, status)
      # puts "Debug - Render Error, Status: #{status}" # Debug output
      render json: { 'error': error_message }, status: status
    end

    def validate_temperature_precision(temperature)
      raise ArgumentError, "Temperature must have fewer than or equal to #{MAX_DECIMAL_PLACES} decimal places" if temperature.to_s =~ /\.(\d{#{MAX_DECIMAL_PLACES + 1},})$/
    end
  end
end
