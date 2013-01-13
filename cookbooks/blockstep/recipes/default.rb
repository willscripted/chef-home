#
# Cookbook Name:: blockstep
# Recipe:: default
#
# Copyright 2013, Will O'Brien
#
# All rights reserved - Do Not Redistribute
#
#unicorn_config "/etc/unicorn/blockstep.rb" do
#  listen 80
#  working_directory "/opt/blockstep/current"
#end
#
#application "blockstep" do
#  
#  packages []
#
#  repository "git@github.com:will-ob/com.blockstep.git"
#  revision "master"
#  deploy_key <<EOF
#-----BEGIN RSA PRIVATE KEY-----
#MIIEpAIBAAKCAQEApVwVZqr/TuJv9OzLVgHBgeojXD5KDAYhg+tYpCkjRWt1YKWa
#mbEGwHHTWT6ZelLSqgyIQl/1PMd4LHz3mA4qJ1B+GMWjT7cRJVSQJA6umvCjdjB+
#Rs2AdnJP9fNg4ojVFPupyVfKP06VH0uibGRUXL4QNRvPMFsJMAJarbwgrLi2tsrw
#fPiwEU9BfNNWVeAT5dRyGVXESLXqaU1x3mfS7mffkayIvDcdnAZm5Avj1nq1fiAk
#XGnt2Aywe2tS9mwrUwmR1r9eMsn2AOIpOWII5ePxkd9ZNaWMqTYem6u4vCy+GxMG
#WehdGPRlX1ffUvOJLXRNJxTnXlm3KWuH9E3BNwIDAQABAoIBAQCJ1QaVrGTg+Qe/
#DP20NAR66JIO2nDYMugO0MXzF8MpoxeUtpT2FMP+9yHm2rINbynfylBtmxSMU+vM
#kWHD4dKrMIHa3ipxULO+/QyksYRC6+AkrOkk1TiGAmS6KuKQEOQj+F2e0UlomXTd
#QCsj1EEpiNdznTmHIeq3lM7Gz/AgZwQNR9saMIe9aBhxrW5omIDGfxm1FaEktJKe
#TvXbreZ7oq4Iw9/K6EYfNz7T9tgp6Qt3CJp6o9JXYVQprkFnj8favYgVQH1z2WtO
#5SQTc0DPJaePbJm/p7t/E0/mGEfEnA0CKVT2cKMtosfEIUwaakihNJkfb/wgNPOu
#YY+YI8Y5AoGBAM6lNEYFPPS5Ajpjc3IK2TlCGuEDBNzNceitNMt/DE2ObnrKZ/xt
#KieOv5zTo3C1qq5QxS3pn7aNTz51eNvPSWuIwQhpXvvM7UI6HQskmq76PFma/37k
#Nss48ff3sHB1sfwv8O1TWT2c7DagsPQOhTvFcuicjK44czSST+ptwS3lAoGBAMza
#k4A1/GJ83nuPYuGZKsEYKXTf5sk0zalT5wfAWf9HHzDA3d43qmEh1DtZsvKaJAFY
#1bH4fBcejxJXqlQSZw4dcL8QM0QK/+CIucDYCtjipAO+rNwtaBYVeWWpDleebb2c
#Wrxyw3iWy7e8YjAwwrK+7Sak2s7IFaCBl4DRjCDrAoGAdY6wPUFPmx0A8nyPOYqI
#ZzV/GxDfnElYCvk2NqpRMnHb0gkBvS3RNG3V/f68VStULRSQB/2HOZAMS8kCd3Hm
#H8HNpt5jBbZgJzPuP9+UDAUZfhRaUzK7JUOBDAMhoeii14fidPDcrNtv2efyovT7
#wLQkGcatlZNRns+5nPDRXC0CgYEApmG9PXwbki6TUU4DZPJPbGfgfAHC45cUlzwD
#QCN1tUYhyipLycnyg1PDmbTgB/Uz2zg40ITe3LRARgiX2hLcSvWUdkqFKPW6H7dN
#D5kpLkDeMAB1S5tBl/Y3FF+7u2R9A2zzsW2Q3+eybHgAU922tREncqSg5yRRlHzM
#/Z60rqMCgYAnx33TOm/Z020BZdYNHsRqSKYk80tfEuq/D0HJ0F6QnpizEQxaOGLi
#3G8DMCWKm9PyXtdm84Rs3ZnPkAm24ZbI75YY5yX/DMaT3Zma5pRUESlc14oehCYT
#X1Iz+Sy2A1cQ2U55svNe4XCOXSuZXW/+kBhjW3NAYYIF4kSvw2KZcg==
#-----END RSA PRIVATE KEY-----
#EOF
#
#  rails do
#
#  end
#
#  unicorn do
#    bundler true
#  end
#
#  nginx do
#
#  end
#end
