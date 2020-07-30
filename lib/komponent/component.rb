# frozen_string_literal: true

module Komponent
  class Component
    class << self
      def all
        component_dirs = components_root.join('*/**/')

        components = {}

        # TODO: list only components directories
        # use ComponentPathResolver?
        Dir.glob(component_dirs).sort.each do |component_dir|
          component_path = Pathname.new(component_dir).relative_path_from(components_root).to_s

          next unless list_this_component_path?(component_path)

          components[component_path] = Component.new(component_path)
        end

        components
      end

      def find(id)
        components = all

        raise Exception, "Component with ID=#{id} not found" unless components.keys.include? id
        components.fetch(id)
      end

      def components_root
        @components_root ||= Rails.application.config.komponent.root.join('components')
      end

      private

      def list_this_component_path?(component_path)
        return false if component_path.starts_with?('komponent/')

        File.exist?(components_root.join(component_path)
            .join("#{component_path.underscore.gsub('/', '_')}_component.rb"))
      end
    end

    attr_reader :id

    def initialize(id)
      @id = id
    end

    def title
      id.titleize
    end

    def path
      Komponent::ComponentPathResolver.new.resolve(@id)
    end

    def examples_view
      "components/#{id}/examples"
    end
  end
end
