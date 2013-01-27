#
# Cookbook Name:: blockstep
# Recipe:: default
#
# Copyright 2013, Will O'Brien
#
# All rights reserved - Do Not Redistribute
#

package 'git'

service "blockstep" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :stop => true, :start => true
  action :nothing
end

rvm_shell 'procfile foreman export' do
  action :nothing
  ruby_string '1.9.3'

  current_path = '/opt/blockstep/current'

  foreman_options = ["HOME=/root foreman export upstart /etc/init"]
  foreman_options << "-a blockstep"
  foreman_options << "-u will"
  foreman_options << "-f Procfile"

  code %{ cd #{current_path} && #{foreman_options.join(" ")} }

end


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


  before_symlink do
    rvm_shell 'procfile bundle install' do
      ruby_string '1.9.3'
      user 'will'
      cwd release_path

      code %{
        bundle install --deployment --without development,test
      }
    end
  end

end



