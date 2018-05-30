Komponent::Engine.routes.draw do
  root to: "styleguide#index"

  resources :styleguide, only: %i[index show] #, path: Komponent.configuration.styleguide_path
end
