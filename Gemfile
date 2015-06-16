source 'https://rubygems.org'

# Use Berkshelf for resolving cookbook dependencies
gem 'berkshelf', '~> 3.0'

# Install omnibus software
gem 'omnibus', '~> 4.0'
#gem 'omnibus', :github => 'opscode/omnibus' # for dmg generation
gem 'omnibus-software', :github => 'opscode/omnibus-software' #, :branch => 'omnibus/3.2-stable'

# Use Test Kitchen with Vagrant for convering the build environment
gem 'test-kitchen',    '~> 1.2'
gem 'kitchen-vagrant', '~> 0.14'

group :test do
  gem 'rake', '~> 10.1.0'
  gem 'serverspec', '~> 2.18.0'
end
