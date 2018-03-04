# frozen_string_literal: true

module KomponentHelper
  def component(component, locals = {}, &block)
    component_path = Komponent::ComponentPathResolver.new.resolve(component)

    parts = component.split("/")
    component_name = parts.join("_")
    component_path = component_path.join("#{component_name}_component")

    require_dependency(component_path)

    component_module = "#{component_name}_component".camelize.constantize
    context = controller.view_context.dup

    context.view_flow = view_flow

    view_renderer = context.view_renderer = context.view_renderer.dup
    lookup_context = view_renderer.lookup_context = view_renderer.lookup_context.dup
    lookup_context.prefixes = ["components/#{component}"]

    context.class_eval { prepend component_module }
    context.class_eval { prepend Komponent::Translation }

    capture_block = proc { capture(&block) } if block

    context.instance_eval do
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

      instance_variable_set(:"@block_given_to_component", block)
    end

    begin
      context.render("components/#{component}/#{parts.join('_')}", &capture_block)
    rescue ActionView::MissingTemplate
      warn "[DEPRECATION WARNING] `#{parts.last}` filename in namespace is deprecated in favor of `#{parts.join('_')}`."
      context.render("components/#{component}/#{parts.last}", &capture_block)
    end
  end
  alias :c :component

  def render_partial(partial_name, locals = {}, &block)
    warn "[DEPRECATION WARNING] `render_partial` is deprecated. Please use default `render` instead."

    context = controller.view_context
    view_paths = context.lookup_context.view_paths.dup
    components_path = Rails.root.join "frontend/components"

    capture_block = proc { capture(&block) } if block

    current_dir = Pathname.new(@virtual_path).dirname

    context.lookup_context.prefixes.prepend current_dir
    context.lookup_context.view_paths.unshift components_path

    rendered_partial = capture do
      context.render partial_name, locals, &capture_block
    end

    context.lookup_context.prefixes.delete current_dir
    context.lookup_context.view_paths = view_paths

    rendered_partial
  end
end
