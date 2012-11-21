#
# Cookbook Name:: myclimate_webapp
# Recipe:: default
#
# Copyright 2012, myclimate
#
# All rights reserved - Do Not Redistribute
#

package 'git-core'
package 'libxslt-dev' # nokogiri depends on this
package 'libxml2-dev' # nokogiri depends on this
package 'libqt4-dev'  # capybara-webkit depends on this (debian specific fix)
# package 'postgresql'



include_recipe 'passenger_apache2::mod_rails'

user 'webapp' do
  password '$1$xkGyj2uw$E3bLRTgMTJo5acqqDn7tW/'
  home '/home/webapp'
  supports :manage_home => true
end

web_app 'webapp' do
  # cookbook 'passenger_apache2' to use the default apache2 vhost template
  # server_name "myproj.#{node[:domain]}"
  # server_aliases [ 'myproj', node[:hostname] ]
  docroot '/home/webapp/current/public'
  rails_env 'production'
end

#git checkout Code

