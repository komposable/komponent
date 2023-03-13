# frozen_string_literal: true

require 'komponent/component'
require File.expand_path('../utils', __FILE__)

module Komponent
  module Generators
    class ExamplesGenerator < Rails::Generators::Base
      include Utils

      source_root File.expand_path('../../component/templates', __FILE__)

      def create_examples_files
        Komponent::Component.all.each do |name, component|
          create_examples_view_file(name)
        end
      end

      protected

      def split_name(name)
        name.split(/[:,::,\/]/).reject(&:blank?).map(&:underscore)
      end

      def component_path(component_name)
        path_parts = [default_path, 'components', *split_name(component_name)]

        Pathname.new(path_parts.join('/'))
      end

      private

      def create_examples_view_file(component_name)
        template "examples.html.#{template_engine}.erb", component_path(component_name) + "_examples.html.#{template_engine}"
      end
    end
  end
end
