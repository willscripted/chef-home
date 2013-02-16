#
# Cookbook Name:: blockstep
# Recipe:: default
#
# Copyright 2013, Will O'Brien
#
# All rights reserved - Do Not Redistribute
#

package 'git'
package 'mongodb-server' do
  action :install
end

service "blockstep" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :stop => true, :start => true
  action :nothing
end

rvm_shell 'procfile foreman export' do
  action :nothing
  ruby_string '1.9.3'
  user 'root'

  current_path = '/opt/blockstep/current'

  foreman_options = ["foreman export upstart /etc/init"]
  foreman_options << "-a blockstep"
  foreman_options << "-u will"
  foreman_options << "-l /opt/blockstep/current/log"
  foreman_options << "-f Procfile"
  foreman_options << "-t /opt/blockstep/shared/templates"

  code %{ cd #{current_path} && HOME=/root bundle exec #{foreman_options.join(" ")} }

end
rvm_shell 'rails3 asset pipeline' do
  action :nothing
  ruby_string '1.9.3'
  user 'will'

  current_path = '/opt/blockstep/current'
  code %{ cd #{current_path} && bundle exec rake assets:precompile }
end

directory "/tmp/keyz/.ssh" do
  owner "will"
  recursive true
end

directory "/opt/blockstep/shared/templates" do
  owner "will"
  group "will"
  mode "755"
  recursive true
end

%w{master.conf.erb process.conf.erb process_master.conf.erb}.each do |f|
  template "/opt/blockstep/shared/templates/#{f}" do
    owner "will"
    source "foreman/#{f}"
    variables :path => "/opt/blockstep/current", :ruby_version => "1.9.3"
  end
end

directory "/opt/blockstep/shared/config" do
  owner "will"
  group "will"
  mode "755"
  recursive true
end

template "/opt/blockstep/shared/config/database.yml" do
  owner "will"
  source "database.yml.erb"
  variables :port => 27017, :database => "blockstep-production", :host => "localhost"
end

execute "chmod blockstep" do
  command "chmod 755 /opt/blockstep -R && chown -R will:will /opt/blockstep"
  user "root"
end

directory "/opt/blockstep/shared/log" do
  owner "will"
  group "will"
  mode "777"
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

execute "nginx site" do
  command "nxensite com.blockstep && nxdissite default && service restart nginx"
  user "root"
  action :nothing
end

template "/etc/nginx/sites-available/com.blockstep" do
  source "nginx/com.blockstep"
  owner "root"
  mode 0644

end

#deploy_revision "blockstep" do
deploy "blockstep" do

  repo "git@github.com:will-ob/com.blockstep.git"
  revision "master"
  environment "development"
  user "will"
  group "will"
  deploy_to "/opt/blockstep"
  action :deploy
  ssh_wrapper "/tmp/keyz/ssh-wrapper.sh"


  before_symlink do
    rvm_shell 'procfile bundle install' do
      ruby_string '1.9.3'
      user 'will'
      cwd release_path

      code %{
        bundle install --deployment --without development test
      }
    end
  end

  notifies :run,     resources("rvm_shell[rails3 asset pipeline]"), :immediate
  notifies :run,     resources("rvm_shell[procfile foreman export]"), :immediate

  notifies :enable,  resources("service[blockstep]"), :delayed
  notifies :restart, resources("service[blockstep]"), :delayed
  notifies :run,     resources("execute[nginx site]"), :delayed

end


