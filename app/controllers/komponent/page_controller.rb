# frozen_string_literal: true

module Komponent
  class PageController < Komponent::ApplicationController
    rescue_from ActionView::MissingTemplate, with: :missing_page

    def show
      @static_page_path = "#{static_page_root}/#{params[:id]}"

      render template: @static_page_path
    end

    private

    def missing_page
      render 'komponent/styleguide/missing_page', status: :not_found
    end
  end
end
