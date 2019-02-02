# frozen_string_literal: true

require 'rails/generators'

module Komponent
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :stimulus, type: :boolean, default: false
      source_root File.join(File.dirname(__FILE__), "templates")

      def check_webpacker_installed
        return if File.directory?(komponent_directory)
        installed = File.exist?(webpacker_configuration_file)
        raise Thor::Error, dependencies_not_met_error_message unless installed
      end

      def create_komponent_directory
        empty_directory(komponent_directory)
        directory(
          javascript_directory,
          komponent_directory,
          recursive: true,
        )
      end

      def alter_webpacker_configuration
        gsub_file(
          webpacker_configuration_file,
          /source_path: app\/javascript$/,
          "source_path: #{komponent_directory}",
        )
      end

      def create_komponent_default_structure
        return if File.exist?(join(components_directory, "index.js"))
        empty_directory(components_directory)
        create_file(join(components_directory, "index.js"))
      end

      def create_stimulus_file
        return if File.exist?(stimulus_application_path)
        return unless stimulus?
        create_file(stimulus_application_path, stimulus_application_template)
      end

      def append_to_application_configuration
        application "config.autoload_paths << config.root.join('#{komponent_directory}/components')"
        application "config.i18n.load_path += Dir[config.root.join('#{komponent_directory}/components/**/*.*.yml')]"
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
        join(komponent_directory, "stimulus_application.js")
      end

      def application_pack_path
        join(komponent_directory, "packs", "application.js")
      end

      def components_directory
        join(komponent_directory, "components")
      end

      def komponent_directory
        default_path
      end

      def webpacker_configuration_file
        join("config", "webpacker.yml")
      end

      def javascript_directory
        join("app", "javascript")
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

      def join(*paths)
        File.expand_path(File.join(*paths), destination_root)
      end
    end
  end
end
