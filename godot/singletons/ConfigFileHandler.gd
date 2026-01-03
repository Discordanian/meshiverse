extends Node


var global_config: ConfigFile = ConfigFile.new()
var vault_config: ConfigFile = ConfigFile.new()



const APP_VERSION: String = "application/config/version"
const GLOBAL_CONFIG_PATH: String = "user://settings.cfg"



func _ready() -> void:
	if !FileAccess.file_exists(GLOBAL_CONFIG_PATH):
		print("Global Config does not exist.  Creating Default Config")
		global_config.set_value("main","version",ProjectSettings.get_setting(APP_VERSION))
		
		global_config.save(GLOBAL_CONFIG_PATH)
	else:
		var error: Error = global_config.load(GLOBAL_CONFIG_PATH)
		if error != OK:
			print("Error loading config file:", error)
		else:
			print("Configuration loaded")
	print_config(global_config)


func set_vault_dir(dir: String) -> void:
	global_config.set_value("vault","path", dir)
	global_config.save(GLOBAL_CONFIG_PATH)
	

func new_vault_dir(dir: String) -> void:
	var vault_settings_file: String = dir.path_join("meshiverse.cfg")
	if FileAccess.file_exists(vault_settings_file):
		print("Error the settings file already exists")
		return
	vault_config = ConfigFile.new()
	vault_config.set_value("main","version", ProjectSettings.get_setting(APP_VERSION))
	vault_config.save(vault_settings_file)
	set_vault_dir(dir)
	

func print_config(config: ConfigFile) -> void:
	print("Printing Configuration File Contents")
	for section: String in config.get_sections():
		for key: String in config.get_section_keys(section):
			print("\t[%s] %s = %s" % [section, key, config.get_value(section,key,"None")])
