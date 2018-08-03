# frozen_string_literal: true

task stats: 'komponent:statsetup'

namespace :komponent do
  task :statsetup => :environment do
    require 'rails/code_statistics'
    Rails.application.config.komponent.component_paths.each do |path|
      ::STATS_DIRECTORIES << ['Components', path]
    end
  end
end
