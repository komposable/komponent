class ComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  class_option :locale, type: :boolean, default: false
  class_option :stimulus, type: :boolean, default: false

  def create_view_file
    template "#{template_prefix}view.html.#{template_engine}.erb", component_path + "_#{name_with_namespace.underscore}.html.#{template_engine}"
  end

  def create_css_file
    template "#{stylesheet_engine}.erb", component_path + "#{name_with_namespace}.#{stylesheet_engine}"
  end

  def create_js_file
    template "js.erb", component_path + "#{name_with_namespace}.js"
    if stimulus?
      template "stimulus_controller_js.erb", component_path + "#{name_with_namespace}_controller.js"
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
    root_path = default_path
    base_path = root_path + "components"

    imports = []

    split_name[0..-2].each do |split|
      base_path += split
      file_path = base_path + "index.js"
      create_file(file_path) unless File.exist?(file_path)
      imports << base_path.relative_path_from(root_path)
    end

    root_path_dup = root_path.dup

    [Pathname.new("components"), *split_name[0..-2]].each do |split|
      root_path_dup += split
      import = imports.shift
      if import
        append_to_file(root_path_dup + "index.js") do
          "\nimport \"#{import}\";\n"
        end
        sort_lines_alphabetically!(root_path_dup + "index.js")
      end
    end

    append_to_file(base_path + "index.js") do
      "\nimport \"#{base_path.relative_path_from(root_path)}/#{component_name}/#{name_with_namespace.underscore}\";\n"
    end
    sort_lines_alphabetically!(base_path + "index.js")
  end

  protected

  def template_prefix
    stimulus? ? "stimulus_" : ""
  end

  def split_name
    name.split(/[:,::,\/]/).reject(&:blank?).map(&:underscore)
  end

  def name_with_namespace
    split_name.join("_")
  end

  def component_path
    path_parts = [default_path, "components", *split_name]

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
    app_generators.rails[:template_engine] || :erb
  end

  def stylesheet_engine
    if sass = rails_configuration.try(:sass)
      sass[:preferred_syntax]
    else
      :css
    end
  end

  def default_path
    rails_configuration.komponent.root
  end

  def locale?
    return options[:locale] if options[:locale]
    komponent_configuration[:locale]
  end

  def stimulus?
    return options[:stimulus] if options[:stimulus]
    komponent_configuration[:stimulus]
  end

  private

  def komponent_configuration
    {
      stimulus: nil,
      locale: nil,
    }.merge(app_generators.komponent)
  end

  def rails_configuration
    Rails.application.config
  end

  def app_generators
    rails_configuration.app_generators
  end

  def sort_lines_alphabetically!(path)
    import_regexp = Regexp.new(/^import "(.*)";$/)
    lines = []

    File.readlines(path).each do |line|
      if line =~ import_regexp
        lines << line
      end
    end

    return if lines.empty?

    lines = lines.sort_by do |line|
      line.match(import_regexp)[1]
    end

    File.open(path, "w") do |f|
      lines.each do |line|
        f.write(line)
      end
    end
  end
end
