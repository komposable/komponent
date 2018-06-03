module Komponent
  class Component
    class << self
      def all
        component_dirs = components_root.join('*/**/')

        components = {}

        # TODO: list only components directories
        Dir.glob(component_dirs).sort.each do |component_dir|
          component_path = Pathname.new(component_dir).relative_path_from(components_root).to_s

          next unless File.exists?(components_root.join(component_path)
            .join("#{File.basename(component_path)}_component.rb"))

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
    end

    attr_reader :id

    def initialize(id)
      @id = id
    end

    def title
      id.titleize
    end

    def example_view
      "components/#{id}/example"
    end
  end
end
