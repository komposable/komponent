class ComponentGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :component, required: true, desc: "Component name, e.g: button"
  class_option :locale, type: :boolean, default: false

  def create_view_file
    template "view.html.slim.erb", component_path + "_#{component}.html.slim"
  end

  def create_css_file
    template "css.erb", component_path + "#{component}.css"
  end

  def create_js_file
    template "js.erb", component_path + "#{component}.js"
  end

  def create_rb_file
    template "rb.erb", component_path + "#{component}_component.rb"
  end

  def create_locale_files
    return unless locale?

    I18n.available_locales.each do |locale|
      @locale = locale
      template "locale.erb", component_path + "#{component}.#{locale}.yml"
    end
  end

  def append_frontend_packs
    append_to_file "frontend/components/index.js" do
      "import \"components/#{component}/#{component}\";"
    end
  end

  protected

  def component_path
    "frontend/components/#{component}/"
  end

  def module_name
    "#{component}_component".camelize
  end

  def locale?
    options[:locale]
  end
end
