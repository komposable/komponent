# frozen_string_literal: true

require 'webpacker'
require 'komponent/component_helper'
require 'komponent/component_path_resolver'
require 'komponent/component_renderer'
require 'komponent/translation'

module Komponent
  class Engine < Rails::Engine
    isolate_namespace Komponent

    config.komponent = ActiveSupport::OrderedOptions.new
    config.komponent.root = nil
    config.komponent.component_paths = []
    config.komponent.stylesheet_engine = :css

    config.before_configuration do |app|
      app.config.komponent = config.komponent
      app.config.komponent.root = app.config.root.join("frontend")
    end

    config.after_initialize do |app|
      app.config.komponent.component_paths.prepend(
        app.config.komponent.root.join("components")
      )
      app.config.komponent.component_paths.append(
        Komponent::Engine.root.join('frontend/components')
      )

      ActiveSupport.on_load :action_view do
        require 'komponent/komponent_helper'
        include KomponentHelper
      end

      ActiveSupport.on_load :action_controller do
        ActionController::Base.prepend_view_path(
          app.config.komponent.root
        )
      end
    end

    initializer "my_engine.action_dispatch" do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.prepend_view_path Komponent::Engine.root.join("frontend")
      end
    end

    initializer 'komponent.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << Komponent::Engine.root.join('frontend')
    end
  end
end
