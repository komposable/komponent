module Komponent
  class Component
    class << self
      def all
        component_dirs = Rails.application.config.komponent.root.join('components').join('**/')

        components = {}

        # TODO: list only components directories
        Dir.glob(component_dirs).sort.map do |component_dir|
          components[component_dir] = Component.new(File.basename(component_dir))
        end

        components
      end

      def find(id)
        components = all

        raise Exception, "Component with ID=#{id} not found" unless components.keys.include? id
        components.fetch(id)
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
