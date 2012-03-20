raw_config = File.read(File.dirname(__FILE__) + "/../app.yml")
APP_CONFIG = YAML.load(raw_config)
