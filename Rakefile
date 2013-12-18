#!/usr/bin/env rake

task ci: [:version, :test]
task default: :ci

task :version do
  sh 'vim --version'
end

task :test do
  sh 'bundle exec vim-flavor test'
end
