## excellent rails configuration solution suggested by Ryan Bates http://railscasts.com/episodes/85-yaml-configuration-file
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
