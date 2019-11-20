# frozen_string_literal: true

module Komponent
  class StyleguideController < ActionController::Base
    layout 'komponent'
    rescue_from ActionView::MissingTemplate, with: :missing_template

    before_action :set_components
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
  end
end
