# frozen_string_literal: true

module Komponent
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :stimulus, type: :boolean, default: false

      def check_webpacker_dependency
        return if komponent_already_installed?

        unless File.exist?(webpacker_configuration_file) and File.directory?(webpacker_default_structure)
          raise Thor::Error, dependencies_not_met_error_message
        end
      end

      def create_root_directory
        return if File.directory?(komponent_root_directory)

        empty_directory(komponent_root_directory)
      end

      def modify_webpacker_configuration
        gsub_file(webpacker_configuration_file, /source_path: app\/javascript$/, "source_path: #{relative_path_from_rails}")
      end

      def move_webpacker_default_structure
        return if File.directory?(komponent_root_directory)

        run("mv #{webpacker_default_structure}/* #{komponent_root_directory}")
      end

      def create_komponent_default_structure
        return if File.exist?(components_directory.join("index.js"))

        empty_directory(components_directory)
        create_file(components_directory.join("index.js"))
      end

      def create_stimulus_file
        return if File.exist?(stimulus_application_path)
        return unless stimulus?

        create_file(stimulus_application_path, stimulus_application_template)
      end

      def append_to_application_configuration
        application "config.autoload_paths << config.root.join('#{relative_path_from_rails}/components')"
        application "config.i18n.load_path += Dir[config.root.join('#{relative_path_from_rails}/components/**/*.*.yml')]"
      end

      def append_to_application_pack
        append_to_file(application_pack_path, "import 'components';")
      end

      def install_stimulus
        if stimulus?
          in_root do
            run("yarn add stimulus")
          end
        end
      end

      protected

      def stimulus_application_template
        <<-JAVASCRIPT
import { Application } from "stimulus";

const application = Application.start();

export default application;
        JAVASCRIPT
      end

      def stimulus_application_path
        komponent_root_directory.join("stimulus_application.js")
      end

      def application_pack_path
        komponent_root_directory.join("packs", "application.js")
      end

      def komponent_root_directory
        default_path
      end

      def components_directory
        Rails.root.join(komponent_root_directory, "components")
      end

      def webpacker_configuration_file
        Rails.root.join("config", "webpacker.yml")
      end

      def webpacker_default_structure
        Rails.root.join("app", "javascript")
      end

      def komponent_already_installed?
        File.directory?(relative_path_from_rails)
      end

      def dependencies_not_met_error_message
        "Seems you don't have webpacker installed in your project. Please install webpacker, and follow instructions at https://github.com/rails/webpacker"
      end

      def stimulus?
        return options[:stimulus] if options[:stimulus]
        komponent_configuration[:stimulus]
      end

      def default_path
        rails_configuration.komponent.root
      end

      def relative_path_from_rails
        default_path.relative_path_from(Rails.root)
      end

      private

      def komponent_configuration
        {
          stimulus: nil,
          locale: nil,
        }.merge(app_generators.komponent)
      end

      def rails_configuration
        Rails.application.config
      end

      def app_generators
        rails_configuration.app_generators
      end
    end
  end
end
