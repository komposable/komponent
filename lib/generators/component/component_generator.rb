class ComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  class_option :locale, type: :boolean, default: false
  class_option :stimulus, type: :boolean, default: false

  def create_view_file
    template "view.html.#{template_engine}.erb", component_path + "_#{name_with_namespace.underscore}.html.#{template_engine}"
  end

  def create_css_file
    template "css.erb", component_path + "#{name_with_namespace}.css"
  end

  def create_js_file
    if stimulus?
      template "js.erb", component_path + "#{name_with_namespace}_controller.js"
    else
      template "stimulus.js.erb", component_path + "#{name_with_namespace}.js"
    end
  end

  def create_rb_file
    template "rb.erb", component_path + "#{module_name.underscore}.rb"
  end

  def create_locale_files
    return unless locale?

    I18n.available_locales.each do |locale|
      @locale = locale
      template "locale.erb", component_path + "#{name_with_namespace}.#{locale}.yml"
    end
  end

  def import_to_packs
    return if stimulus?
    root_path = Pathname.new("frontend")
    base_path = root_path + "components"

    imports = []

    split_name[0..-2].each do |split|
      base_path += split
      file_path = base_path + "index.js"
      create_file(file_path) unless File.exists?(file_path)
      imports << base_path.relative_path_from(root_path)
    end

    root_path_dup = root_path.dup

    [Pathname.new("components"), *split_name[0..-2]].each do |split|
      root_path_dup += split
      import = imports.shift
      if import
        append_to_file(root_path_dup + "index.js") do
          "import \"#{import}\";\n"
        end
      end
    end

    append_to_file(base_path + "index.js") do
      "import \"#{base_path.relative_path_from(root_path)}/#{component_name}/#{component_name}\";\n"
    end
  end

  protected

  def split_name
    name.split(/[:,::,\/]/).reject(&:blank?).map(&:underscore)
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

  def stimulus?
    options[:stimulus] || configuration[:stimulus]
  end

  def configuration
    {stimulus: false}.merge Rails.application.config.app_generators.komponent
  end
end
