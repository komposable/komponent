Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'pages/view_only',                to: 'pages#view_only'
  get 'pages/partial_render',           to: 'pages#partial_render'
  get 'pages/komponent_render',         to: 'pages#komponent_render'
  get 'pages/komponent_partial_render', to: 'pages#komponent_partial_render'
end
