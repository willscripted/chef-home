log_level                :info
log_location             STDOUT
node_name                'will'
client_key               'will.pem'
validation_client_name   'chef-validator'
validation_key           'validation.pem'
chef_server_url          'http://chef.blockstep.com:4000'
cookbook_path            '../cookbooks'
cache_type               'BasicFile'
cache_options( :path => 'checksums' )
