# frozen_string_literal: true

module Komponent
  class ComponentRenderer
    attr_reader :context

    def initialize(controller)
      @context = controller.view_context.dup
      @view_renderer = @context.view_renderer = @context.view_renderer.dup
      @lookup_context = @view_renderer.lookup_context = @view_renderer.lookup_context.dup
    end

    def render(component, locals = {}, &block)
      parts = component.split("/")
      component_name = parts.join("_")

      component_module_path = resolved_component_path(component)
        .join("#{component_name}_component")
      require_dependency(component_module_path)
      component_module = "#{component_name}_component".camelize.constantize

      @context.class_eval { prepend component_module }
      @context.class_eval { prepend Komponent::Translation }

      @lookup_context.prefixes = ["components/#{component}"]

      capture_block = proc { capture(&block) } if block

      @context.instance_eval do
        if component_module.respond_to?(:properties)
          locals = locals.dup
          component_module.properties.each do |name, options|
            unless locals.has_key?(name)
              if options.has_key?(:default)
                locals[name] = options[:default]
              elsif options[:required]
                raise "Missing required component parameter: #{name}"
              end
            end
          end
        end

        locals.each do |name, value|
          instance_variable_set(:"@#{name}", locals[name])
        end

        instance_variable_set(:"@block_given_to_component", capture_block)

        define_singleton_method(:properties) { locals }
        define_singleton_method(:block_given_to_component?) { !!block }
      end

      begin
        @context.render("components/#{component}/#{parts.join('_')}", &capture_block)
      rescue ActionView::MissingTemplate
        warn "[DEPRECATION WARNING] `#{parts.last}` filename in namespace is deprecated in favor of `#{parts.join('_')}`."
        @context.render("components/#{component}/#{parts.last}", &capture_block)
      end
    end

    private

    def resolved_component_path(component)
      Komponent::ComponentPathResolver.new.resolve(component)
    end
  end
end
