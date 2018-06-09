# frozen_string_literal: true

require 'komponent/component'

module Komponent
  module Generators
    class ExamplesGenerator < Rails::Generators::Base
      source_root File.expand_path('../../component/templates', __FILE__)

      def create_example_files
        Komponent::Component.all.each do |name, component|
          @name = name
          create_example_view_file
        end
      end

      protected

      # TODO: refactoring
      # all methods below come from ComponentGenerator
      def split_name
        @name.split(/[:,::,\/]/).reject(&:blank?).map(&:underscore)
      end

      def component_path
        path_parts = [default_path, "components", *split_name]

        Pathname.new(path_parts.join("/"))
      end

      def component_name
        split_name.last.underscore
      end

      def rails_configuration
        Rails.application.config
      end

      def app_generators
        rails_configuration.app_generators
      end

      def template_engine
        app_generators.rails[:template_engine] || :erb
      end

      def default_path
        rails_configuration.komponent.root
      end

      private

      def create_example_view_file
        template "example.html.#{template_engine}.erb", component_path + "_example.html.#{template_engine}"
      end
    end
  end
end
