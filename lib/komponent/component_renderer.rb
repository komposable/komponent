# frozen_string_literal: true

module Komponent
  class ComponentRenderer
    include ActionView::Helpers::CaptureHelper

    attr_accessor :output_buffer
    attr_reader :context

    def initialize(controller, view_flow = nil)
      @context = controller.view_context.dup
      @view_renderer = @context.view_renderer = @context.view_renderer.dup
      @lookup_context = @view_renderer.lookup_context = @view_renderer.lookup_context.dup
      @view_flow = view_flow
    end

    def render(component, locals = {}, options = {}, &block)
      cached = options.delete(:cached)
      if cached

        cached_block = block ? block.call : nil
        key = [component, locals, options, cached_block].to_s
        cache_key = Digest::SHA1.hexdigest(key)

        Rails.cache.fetch(cache_key) do
          _render(component, locals, options, &block)
        end
      else
        _render(component, locals, options, &block)
      end
    end

    private

    def _render(component, locals = {}, options = {}, &block)
      parts = component.split("/")
      component_name = parts.join("_")

      component_module_path = resolved_component_path(component)
        .join("#{component_name}_component")
      require_dependency(component_module_path)
      component_module = "#{component_name}_component".camelize.constantize

      @context.view_flow = @view_flow if @view_flow
      @context.class_eval { prepend component_module }
      @context.class_eval { prepend Komponent::Translation }

      @lookup_context.prefixes = ["components/#{component}"]

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

        define_singleton_method(:properties) { locals }
        define_singleton_method(:block_given_to_component?) { block_given? }
        define_singleton_method(:block_given_to_component) { block }
      end

      @context.render("components/#{component}/#{parts.join('_')}", &block)
    end

    def resolved_component_path(component)
      Komponent::ComponentPathResolver.new.resolve(component)
    end
  end
end
