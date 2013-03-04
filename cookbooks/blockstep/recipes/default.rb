#
# Cookbook Name:: blockstep
# Recipe:: default
#
# Copyright 2013, Will O'Brien
#
# All rights reserved - Do Not Redistribute
#

deploy_path = "/opt/blockstep"
current_path = ::File.join(deploy_path, "current")

ruby_version = '2.0.0'

key_dir = "/tmp/keyz"
key_file = "ssh-wrapper.sh"

deploy_user = "will"
deploy_group = "will"

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
  ruby_string ruby_version
  user 'root'

  upstart_templates_dir = ::File.join(deploy_path, "shared/templates")
  log_path = ::File.join(current_path, "log")

  foreman_options = ["foreman export upstart /etc/init"]
  foreman_options << "-a blockstep"
  foreman_options << "-e .env"
  foreman_options << "-u #{deploy_user}"
  foreman_options << "-l #{log_path}"
  foreman_options << "-f Procfile"
  foreman_options << "-t #{upstart_templates_dir}"

  code %{ cd #{current_path} && HOME=/root bundle exec #{foreman_options.join(" ")} }

end

rvm_shell 'rails3 asset pipeline' do
  action :nothing
  ruby_string ruby_version
  user deploy_user

  code %{ cd #{current_path} && bundle exec rake assets:precompile }
end

directory ::File.join(key_dir, ".ssh") do
  owner deploy_user
  recursive true
end

directory ::File.join(deploy_path, "shared/templates") do
  owner deploy_user
  group deploy_group
  mode "755"
  recursive true
end

%w{master.conf.erb process.conf.erb process_master.conf.erb}.each do |f|
  template ::File.join(deploy_path, "shared/templates/#{f}") do
    owner deploy_user
    source "foreman/#{f}"
    variables :path => current_path, :ruby_version => "1.9.3"
  end
end

directory ::File.join(deploy_path, "shared/config") do
  owner deploy_user
  group deploy_group
  mode "755"
  recursive true
end

template ::File.join(deploy_path, "shared/config/database.yml") do
  owner deploy_user
  source "database.yml.erb"
  variables({
    :port     => node["blockstep"]["database"]["port"],
    :database => node["blockstep"]["database"]["name"],
    :host     => node["blockstep"]["database"]["host"]
  })
end

execute "chmod blockstep" do
  command "chmod 755 #{deploy_path} -R && chown -R #{deploy_user}:#{deploy_group} #{deploy_path}"
  user "root"
end

directory ::File.join(deploy_path, "shared/log") do
  owner deploy_user
  group deploy_group
  mode "777"
  recursive true
end

cookbook_file ::File.join(key_dir, ".ssh/id_deploy") do
  source "id_deploy"
  owner deploy_user
  mode 0600
end

cookbook_file ::File.join(key_dir, key_file) do
  source key_file
  owner deploy_user
  mode 0700
end


template "/etc/nginx/sites-available/com.blockstep" do
  source "nginx/com.blockstep.erb"
  owner "root"
  mode 0644

  variables({
    :port => node["blockstep"]["env"]["port"], 
    :name => node["blockstep"]["hostname"]
  })
end

execute "nginx site" do
  command "nxensite com.blockstep && nxdissite default || true  && service nginx restart"
  user "root"
end

template ::File.join(deploy_path, "shared/env") do
  source "env.erb"
  variables :env => node["blockstep"]["env"]

  notifies :run, resources("rvm_shell[procfile foreman export]"), :delayed
  notifies :restart, resources("service[blockstep]"), :delayed
end

deploy_revision "blockstep" do

  action :force_deploy
  repo "git@github.com:will-ob/com.blockstep.git"
  revision node["blockstep"]["branch"]
  user deploy_user
  group deploy_group
  deploy_to deploy_path
  ssh_wrapper ::File.join(key_dir, key_file)

  symlinks({'env' => '.env' })
  before_symlink do
    rvm_shell 'procfile bundle install' do
      ruby_string ruby_version
      user deploy_user
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


