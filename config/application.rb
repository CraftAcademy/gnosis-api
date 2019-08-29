require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module GnosisApi
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = true
    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.view_specs false
      generate.controller_specs false
      generate.routing_specs false
      generate.helper_specs false

      config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '*', 
            headers: :any, 
            methods: %i[get post put delete],
            expose: %w(access-token expiry token-type uid client)
        end
      end
    end

     config.stripe.secret_key = Rails.application.credentials.stripe[:secret_key]
     config.stripe.publishable_key = Rails.application.credentials.stripe[:publishable_key]
  end
end
