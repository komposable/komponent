module Komponent
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def check_webpacker_dependency
        unless File.exists?(webpacker_configuration_file) and File.directory?(webpacker_default_structure)
          raise Thor::Error, dependencies_not_met_error_message
        end
      end

      def create_root_directory
        empty_directory(komponent_root_directory)
      end

      def modify_webpacker_configuration
        gsub_file(webpacker_configuration_file, /source_path: app\/javascript$/, "source_path: frontend")
      end

      def move_webpacker_default_structure
        run("mv #{webpacker_default_structure}/* #{komponent_root_directory}")
      end

      def create_komponent_default_structure
        empty_directory(components_directory)
        create_file(components_directory.join("index.js"))
      end

      def append_to_application_pack
        append_to_file(application_pack_path, "import 'components';")
      end

      private

      def application_pack_path
        komponent_root_directory.join("packs", "application.js")
      end

      def komponent_root_directory
        Rails.root.join("frontend")
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

      def dependencies_not_met_error_message
        "Seems you don't have webpacker installed in your project. Please install webpacker, and follow instructions at https://github.com/rails/webpacker"
      end
    end
  end
end
