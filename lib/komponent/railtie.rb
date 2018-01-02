require 'komponent/core/component_helper'

module Komponent
  class Railtie < Rails::Railtie
    initializer "komponent.action_view" do |app|
      ActiveSupport.on_load :action_view do
        require 'komponent/komponent_helper'
        include KomponentHelper
      end
    end

    initializer "komponent.action_dispatch" do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.prepend_view_path "#{app.config.root}/frontend"
      end
    end

    initializer "komponent.i18n" do |app|
      ActiveSupport.on_load :i18n do
        I18n.load_path.concat(Dir["#{app.config.root}/frontend/components/**/*.yml"])
      end
    end

    initializer 'komponent.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << "#{app.config.root}/frontend"
    end
  end
end
