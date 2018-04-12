# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rake/testtask"
require "cucumber"
require "cucumber/rake/task"
require "coveralls/rake/task"

namespace :test do
  task all: [:rubocop, :unit, :cucumber]
  task all_with_coverage: [:all, "coveralls:push"]

  RuboCop::RakeTask.new

  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/**/*_test.rb"]
    t.verbose = true
    t.warning = false
  end

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
  end

  Coveralls::RakeTask.new
end

task test: "test:all"

task default: :test
