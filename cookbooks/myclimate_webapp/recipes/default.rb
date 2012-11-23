#
# Cookbook Name:: myclimate_webapp
# Recipe:: default
#
# Copyright 2012, myclimate
#
# All rights reserved - Do Not Redistribute
#

################  CHEF SETUP ###############################
# I. install ruby (from source) using this gist (based on Ryan Bates') and chef (later chef-solo) with:
# On the server run
# curl -L https://gist.github.com/raw/4086244/4c47ed1d4cd6919a6dcaa702571c09b30499c348/gistfile1.txt | bash
# II.
# knife bootstrap IP -x root -P <password> to configure the chef-client
# Execute the following steps with:
# knife ssh name:<server_name> -x root -P <password> "chef-client"

package 'git-core'
package 'libxslt-dev' # nokogiri depends on this
package 'libxml2-dev' # nokogiri depends on this
package 'libqt4-dev'  # capybara-webkit depends on this (debian specific fix)

include_recipe 'postgresql::server'
include_recipe 'postgresql::server_debian'
include_recipe 'passenger_apache2::mod_rails'

user 'webapp' do
  password '$1$xkGyj2uw$E3bLRTgMTJo5acqqDn7tW/'
  home '/home/webapp'
  supports :manage_home => true
end

web_app 'webapp' do
  docroot '/home/webapp/current/public'
  rails_env 'production'
end

# Set passenger-config and postgresql-confige in here not in the passenger cookbook
# But how do I do that?

directory '/home/webapp/current'

directory '/root/.ssh'

execute 'ssh-keyscan -H github.com >> ~/.ssh/known_hosts' do
  not_if 'test -d /home/webapp/current/app'
end

execute 'git clone git@github.com:Mar-vin/Progriss.git /home/webapp/current' do
  not_if 'test -d /home/webapp/current/app'
end

execute '/opt/chef/embedded/bin/bundle install' do
  cwd '/home/webapp/current'
end

execute 'createuser --no-superuser --createdb --no-createrole progress' do
  user 'postgres'
end

execute '/opt/chef/embedded/bin/bundle exec /opt/chef/embedded/bin/rake db:setup' do
  ENV['RAILS_ENV'] = 'production'
  cwd '/home/webapp/current'
end

file '/etc/apache2/sites-enabled/000-default' do
  action :delete #This doesn't work for some reason
end

service 'apache2' do
  action :start
end

# configure postgresql -> create db

# compile assets -> execute or capistrano?
# copy assets -> execute or capistrano?
