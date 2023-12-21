Rails.application.routes.draw do
  namespace :v1 do
    post '/convert_temperature', to: 'temperature_converter#convert'
  end
end
