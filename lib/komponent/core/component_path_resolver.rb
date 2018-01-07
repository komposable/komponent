module Komponent
  class ComponentPathResolver
    attr_accessor :path

    def initialize(component)
      @component = component
      resolve
    end

    protected

    def resolve
      component_found = nil

      component_paths.each do |component_path|
        component_found = find_component(component_path)
        break if component_found
      end

      raise ComponentPathResolver::MissingComponentError.new(component_paths) unless component_found

      component_parts.each do |part|
        component_found += part
      end

      @path = Pathname.new(component_found)
    end

    def find_component(component_path)
      pattern = /#{component_parts.join("_")}_component.rb/
      Find.find(component_path.to_s) do |path|
        return Pathname.new(component_path) if path =~ pattern
      end
    end

    def component_parts
      @component.split("/")
    end

    def component_paths
      app_configuration.komponent.component_paths
    end

    def app_configuration
      Rails.application.config
    end

    class MissingComponentError < StandardError
      def initialize(paths)
        @paths = paths

        super(message)
      end

      private

      def message
        message = "Component not found in:\n"
        @paths.each do |path|
          message += "  * #{path}\n"
        end
        message
      end
    end
  end
end
