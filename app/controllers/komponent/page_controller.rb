# frozen_string_literal: true

module Komponent
  class PageController < Komponent::ApplicationController
    rescue_from ActionView::MissingTemplate, with: :missing_page

    def show
      render template: "komponent/static/#{params[:id]}"
    end

    private

    def missing_page
      render 'komponent/styleguide/missing_page', status: :not_found
    end
  end
end
