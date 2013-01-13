log_level                :info
log_location             STDOUT
node_name                'will'
client_key               '/home/will/chef-home/.chef/will.pem'
validation_client_name   'chef-validator'
validation_key           '/home/will/chef-home/.chef/validation.pem'
chef_server_url          'http://chef.blockstep.com:4000'
cookbook_path            '~/chef-home/cookbooks'
cache_type               'BasicFile'
cache_options( :path => 'checksums' )
