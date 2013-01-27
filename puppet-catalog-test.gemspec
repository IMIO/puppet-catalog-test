Gem::Specification.new do |s|
  s.name = 'puppet-catalog-test'
  s.version = '0.1.0'
  s.homepage = 'https://github.com/invadersmustdie/puppet-catalog-test/'
  s.summary = 'Tests all your puppet catalogs for compiler errors'
  s.description = 'Tests all your puppet catalogs for compiler errors.'

  s.executables = ['puppet-catalog-test']

  s.files = [
    'bin/puppet-catalog-test',
    'LICENSE',
    'Rakefile',
    'README.md',
    'puppet-catalog-test.gemspec'
  ]

  s.files += Dir["lib/**/*"]

  s.add_dependency 'puppet'

  s.authors = ['Rene Lengwinat']
  s.email = 'rene.lengwinat@googlemail.com'
end
