# frozen_string_literal: true

Komponent::Engine.routes.draw do
  resources :styleguide, only: %i[index show]
end
