# frozen_string_literal: true

module Komponent
  class StyleguideController < ActionController::Base
    layout 'komponent'
    rescue_from ActionView::MissingTemplate, with: :missing_template

    before_action :set_components
    around_action :set_locale

    def index; end

    def show
      @component = Komponent::Component.find(params[:id])
    end

    private

    def set_components
      @components = Komponent::Component.all
    end

    def missing_template
      render 'komponent/styleguide/missing_template', status: :not_found
    end

    def set_locale
      I18n.with_locale(params[:locale] || I18n.default_locale) do
        yield
      end
    end
  end
end
