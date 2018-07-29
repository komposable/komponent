# frozen_string_literal: true

task stats: 'komponent:statsetup'

namespace :komponent do
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ['Components', './frontend/components']
  end
end
