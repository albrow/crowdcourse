# load the libraries
require 'aws'

# log requests using the default rails logger
AWS.config(:logger => Rails.logger)

# load credentials from a file
creds = YAML.load_file("#{Rails.root}/config/amazon_s3.yml")[Rails.env]
AWS.config(creds)