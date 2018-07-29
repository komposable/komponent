# frozen_string_literal: true

module Komponent
  class StyleguideController < ::ApplicationController
    layout 'komponent'
    rescue_from ActionView::MissingTemplate, with: :missing_template

    def index; end

    def show
      @component = Komponent::Component.find(params[:id])
    end

    private

    def missing_template
      render 'komponent/styleguide/missing_template', status: :not_found
    end
  end
end
