class ComponentGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :component, required: true, desc: "Component name, e.g: button"
  class_option :locale, type: :boolean, default: false

  def create_view_file
    template "view.html.#{template_engine}.erb", component_path + "_#{component_name}.html.#{template_engine}"
  end

  def create_css_file
    template "css.erb", component_path + "#{component_name}.css"
  end

  def create_js_file
    template "js.erb", component_path + "#{component_name}.js"
  end

  def create_rb_file
    template "rb.erb", component_path + "#{component_name}_component.rb"
  end

  def create_locale_files
    return unless locale?

    I18n.available_locales.each do |locale|
      @locale = locale
      template "locale.erb", component_path + "#{component_name}.#{locale}.yml"
    end
  end

  def append_frontend_packs
    append_to_file "frontend/components/index.js" do
      "import \"components/#{component_name}/#{component_name}\";"
    end
  end

  protected

  def component_path
    "frontend/components/#{component_name}/"
  end

  def module_name
    "#{component_name}_component".camelize
  end
  
  def component_name
    component.underscore
  end

  def template_engine
    Rails.application.config.app_generators.rails[:template_engine] || :erb
  end

  def locale?
    options[:locale]
  end
end
