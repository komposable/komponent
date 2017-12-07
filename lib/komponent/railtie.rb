require 'komponent/komponent_helper'
require 'komponent/core/component_helper'

module Komponent
  class Railtie < Rails::Railtie
    initializer "komponent.helper" do |app|
      ActionView::Base.send :include, KomponentHelper
    end

    initializer "komponent.controller" do |app|
      ActionController::Base.prepend_view_path "#{app.config.root}/frontend"
    end

    initializer "komponent.i18n" do |app|
      ActiveSupport.on_load :i18n do
        I18n.load_path.concat(Dir["#{app.config.root}/frontend/components/*/*.yml"])
      end
    end

    initializer 'komponent.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << "#{app.config.root}/frontend"
    end
  end
end
