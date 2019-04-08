lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ult_kansuji/version'

Gem::Specification.new do |spec|
  spec.name          = 'ult_kansuji'
  spec.version       = UltKansuji::VERSION
  spec.authors       = ['Tatsuki Sugiura']
  spec.email         = ['sugi@nemui.org']

  spec.summary       = 'Japanese kansuji library for ruby'
  spec.description   = 'Pure ruby library of Japanese kansuji. Bi-directional convert support between number and kanji string.'
  spec.homepage      = 'https://github.com/sugi/ult_kansuji'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + %w(LICENSE.txt README.md ChangeLog)
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.9'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
end
