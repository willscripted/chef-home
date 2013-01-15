#
# Cookbook Name:: blockstep
# Recipe:: default
#
# Copyright 2013, Will O'Brien
#
# All rights reserved - Do Not Redistribute
#

package 'git'

unicorn_config "/etc/unicorn/blockstep.rb" do
  listen 80 => {:tcp_nodelay => true, :backlog => 100 }
  working_directory "/opt/blockstep/current"
end

directory "/tmp/keyz/.ssh" do
  owner "will"
  recursive true
end

cookbook_file "/tmp/keyz/.ssh/id_deploy" do
  source "id_deploy"
  owner "will"
  mode 0600
end

cookbook_file "/tmp/keyz/ssh-wrapper.sh" do
  source "ssh-wrapper.sh"
  owner "will"
  mode 0700
end

deploy "blockstep" do
  repo "git@github.com:will-ob/com.blockstep.git"
  revision "master"
  environment "development"
  user "will"
  deploy_to "/opt/blockstep"
  action :deploy
  ssh_wrapper "/tmp/keyz/ssh-wrapper.sh"
end

