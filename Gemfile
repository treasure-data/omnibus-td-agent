source 'https://rubygems.org'

# Use Berkshelf for resolving cookbook dependencies
gem 'berkshelf', '~> 6.0'

# Install omnibus software
# gem 'omnibus', '5.5'
gem 'omnibus', :git => 'https://github.com/chef/omnibus.git', :ref => '70855aab656d333622c51171828b4f41d04f6ef5'
#gem 'omnibus-software', :git => 'https://github.com/chef/omnibus-software.git'
gem 'omnibus-software', :git => 'https://github.com/chef/omnibus-software.git', :ref => '09a3cb0550d4a54c197246583658a0255bda7a36'

# Use Test Kitchen with Vagrant for convering the build environment
gem 'test-kitchen',    '~> 1.2'
gem 'kitchen-vagrant', '~> 0.14'

group :test do
  gem 'rake', '~> 10.1.0'
  gem 'serverspec', '~> 2.18.0'
end
