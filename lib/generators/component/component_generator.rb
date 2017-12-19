class ComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

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
    template "rb.erb", component_path + "#{module_name.underscore}.rb"
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
      "import \"components/#{split_name.join("/")}/#{component_name}\";\n"
    end
  end

  protected

  def split_name
    name.split(/[:,::,\/]/).reject(&:blank?)
  end

  def name_with_namespace
    split_name.join("_")
  end

  def component_path
    path_parts = ["frontend", "components", *split_name]

    Pathname.new(path_parts.join("/"))
  end

  def module_name
    "#{name_with_namespace}_component".camelize
  end

  def component_class_name
    name_with_namespace.dasherize
  end
  
  def component_name
    split_name.last.underscore
  end

  def template_engine
    Rails.application.config.app_generators.rails[:template_engine] || :erb
  end

  def locale?
    options[:locale]
  end
end
