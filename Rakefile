require "rake"
require "rspec/core/rake_task"
require 'ci/reporter/rake/rspec'

Dir.glob("lib/tasks/**/*").sort.each { |ext| load(ext) }

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "cfoundry/version"

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc "Run specs producing results for CI"
task 'ci:spec' => ['ci:setup:rspec', :spec]