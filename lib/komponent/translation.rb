# frozen_string_literal: true

module Komponent
  module Translation
    def translate(key, options = {})
      virtual_path = @virtual_path

      is_component = key.to_s.first == "." &&
        virtual_path =~ /^components/

      if is_component
        matches = virtual_path.match(/^components\/(?<folders>.+)\/_(?<view_name>.+)/)
        folders = matches['folders'].split('/')
        view_name = matches['view_name']

        top_level_folder = folders.shift

        path = "#{top_level_folder}_component"
        path += ".#{folders.join('.')}" if folders.any?
        path += ".#{view_name}" if view_name != top_level_folder # partial scope

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
