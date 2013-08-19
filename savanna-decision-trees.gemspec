$:.unshift File.expand_path('../lib/', __FILE__)
require 'savanna-decision-trees/version'
require 'date'

Gem::Specification.new do |gem|
  gem.name = 'savanna-decision-trees'
  gem.version = Savanna::DecisionTrees::VERSION
  gem.date = Date.today.to_s
  gem.license = 'MIT'
  gem.summary = %Q{Decision Trees as They Should Be}
  gem.description = %Q{Read more documentation at repository homepage.}
  gem.authors = ['Max Makarochkin']
  gem.email = 'maxim.makarochkin@gmail.com'
  gem.homepage = 'https://github.com/savanna-initiative/savanna-decision-trees'
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 1.9.3'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
