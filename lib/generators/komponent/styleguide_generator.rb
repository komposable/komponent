# frozen_string_literal: true

require File.expand_path('../utils', __FILE__)

module Komponent
  module Generators
    class StyleguideGenerator < Rails::Generators::Base
      include Utils

      source_root File.expand_path('../templates/styleguide', __FILE__)

      def check_komponent_dependency
        unless komponent_already_installed?
          raise Thor::Error, dependencies_not_met_error_message
        end
      end

      def copy_styleguide_components
        directory 'components', components_directory.join('komponent')
      end

      def create_komponent_pack
        template 'packs/komponent.js', komponent_pack_path
      end

      def append_to_application_routes
        route 'mount Komponent::Engine => \'/\' if Rails.env.development?'
      end

      protected

      def komponent_pack_path
        komponent_root_directory.join('packs', 'komponent.js')
      end

      def dependencies_not_met_error_message
        'Seems you don\'t have komponent installed in your project. Please install komponent, and follow instructions at https://github.com/komposable/komponent'
      end
    end
  end
end
