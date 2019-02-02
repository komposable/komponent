# frozen_string_literal: true

module Komponent
  module Generators
    module Utils
      protected

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

      def relative_path_from_rails
        default_path.relative_path_from(Rails.root)
      end

      def komponent_root_directory
        default_path
      end

      def komponent_configuration
        {
          stimulus: nil,
          locale: nil,
          examples: nil,
        }.merge(app_generators.komponent)
      end

      def components_directory
        Rails.root.join(komponent_root_directory, 'components')
      end

      def komponent_already_installed?
        File.directory?(relative_path_from_rails)
      end
    end
  end
end
