require "komponent/component"

module Komponent
  class StyleguideController < ::ApplicationController
    layout 'komponent'

    before_action :set_components

    # helper "mountain_view/styleguide"

    def index; end

    def show
      @component = Komponent::Component.find(params[:id])
    end

    private

    def set_components
      @components = Komponent::Component.all
    end
  end
end
