extends Node


var global_config = ConfigFile.new()
const GLOBAL_CONFIG_PATH = "user://settings.cfg"

func _ready():
	if !FileAccess.file_exists(GLOBAL_CONFIG_PATH):
		print("Global Config does not exist.  Creating Default Config")
		global_config.set_value("main","version",ProjectSettings.get_setting("application/config/version"))
		
		global_config.save(GLOBAL_CONFIG_PATH)
	else:
		var error = global_config.load(GLOBAL_CONFIG_PATH)
		if error != OK:
			print("Error loading config file:", error)
		else:
			print("Configuration loaded")
	print_config(global_config)

func print_config(config: ConfigFile):
	print("Printing Configuration File Contents")
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			print("\t[%s] %s = %s" % [section, key, config.get_value(section,key,"None")])
