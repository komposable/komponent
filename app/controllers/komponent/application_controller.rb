# frozen_string_literal: true

module Komponent
  class ApplicationController < ActionController::Base
    layout 'komponent'

    before_action :set_components
    before_action :set_static_pages
    around_action :set_locale

    private

    def set_components
      @components = Komponent::Component.all
    end

    def set_static_pages
      @static_pages ||= Dir["#{Rails.root.join("app/views/komponent/static/*.html.*")}"].map do |path|
        Pathname.new(path).basename(".*").basename(".*").to_s
      end
    end

    def set_locale
      I18n.with_locale(params[:locale] || I18n.default_locale) do
        yield
      end
    end
  end
end
