#
# Cookbook Name:: myclimate_webapp
# Recipe:: default
#
# Copyright 2012, myclimate
#
# All rights reserved - Do Not Redistribute
#

user 'webapp' do
  password '$1$xkGyj2uw$E3bLRTgMTJo5acqqDn7tW/'
  home '/home/webapp'
  supports :manage_home => true
end

gem_package 'passenger'