# frozen_string_literal: true

module Komponent
  module Translation
    def translate(key, options = {})
      virtual_path = @virtual_path

      is_component = key.to_s.first == "." &&
        virtual_path =~ /^components/

      if is_component
        matches = virtual_path.match(/^components\/(?<folders>.+)\/_(?<view_name>.+)/)
        folders, view_name = matches['folders'], matches['view_name']

        component_name = folders.gsub('/', '_')

        path = "#{component_name}_component"
        path += ".#{view_name}" if view_name != component_name # partial scope

        defaults = [:"#{path}#{key}"]
        defaults << options[:default] if options[:default]
        options[:default] = defaults.flatten
        key = "#{path}.#{key}"
      end

      super(key, options)
    end
    alias :t :translate
  end
end
