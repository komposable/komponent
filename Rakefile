# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require 'cucumber'
require 'cucumber/rake/task'

namespace :test do
  task all: [:unit, :cucumber]

  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/**/*_test.rb"]
    t.verbose = true
  end

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
  end
end

task test: 'test:all'

task default: :test
