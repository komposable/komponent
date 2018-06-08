# frozen_string_literal: true

require "komponent/component"

module Komponent
  class StyleguideController < ::ApplicationController
    layout 'komponent'

    def index; end

    def show
      @component = Komponent::Component.find(params[:id])
    end
  end
end
