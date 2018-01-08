module Komponent
  module Translation
    def translate(key, options = {})
      virtual_path = @virtual_path

      is_component = key.to_s.first == "." and
        virtual_path =~ /^components/

      if is_component
        path = virtual_path.match(/^components\/.+\/_(.+)/)[1]
        path += "_component"
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
