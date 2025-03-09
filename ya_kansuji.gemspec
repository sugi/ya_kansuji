lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ya_kansuji/version'

Gem::Specification.new do |spec|
  spec.name          = 'ya_kansuji'
  spec.version       = YaKansuji::VERSION
  spec.authors       = ['Tatsuki Sugiura']
  spec.email         = ['sugi@nemui.org']

  spec.summary       = 'Japanese kansuji library for ruby'
  spec.description   = <<-DESC
Pure ruby library of Japanese kansuji.
Bi-directional convert support between number and kanji string.
  DESC
  spec.homepage      = 'https://github.com/sugi/ya_kansuji'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + %w(LICENSE.txt README.md ChangeLog)
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
