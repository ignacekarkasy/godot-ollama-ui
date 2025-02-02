extends Node

const BASE_PATH = "res://"
const CONFIG_FILE_PATH = BASE_PATH + "config.tres"
const CHAT_SAVE_PATH = BASE_PATH + "Chats/"
const CHAT_FILE_SAVE_PATH = CHAT_SAVE_PATH + "%s.tres"
var config: Config

func _ready():
	DirAccess.make_dir_absolute(CHAT_SAVE_PATH)
	if not config_exists():
		config = Config.new()
		save_config()
	load_config()
	IP.resolve_hostname(create_domain(), IP.TYPE_IPV4)
	TranslationServer.set_locale(config.language_map.get(config.language))

func create_domain()->String:
	return get_host_protocol() + get_config_ip() + ':' + get_config_port()

func get_generate_url():
	return create_domain() + config.api_generate_url

func get_tags_url():
	return create_domain() + config.api_tags

func get_version_url():
	return create_domain() + config.api_version

func get_ollama_header():
	return config.header

func get_config_protocol():
	return config.host_protocol

func change_default_model(new_model_name: String)->void:
	config.host_model = new_model_name
	save_config()

func change_language(new_language: Config.Language)->void:
	config.language = new_language
	TranslationServer.set_locale(config.language_map.get(config.language))
	save_config()

func change_host_ip(new_ip: String)->void:
	config.host_ip = new_ip
	save_config()

func change_host_port(new_port: String)->void:
	config.host_port = new_port
	save_config()

func change_host_protocol(new_protocol: Config.Protocol)->void:
	config.host_protocol = new_protocol
	save_config()

func get_host_protocol():
	return config.protocol_map.get(config.host_protocol)

func get_config_ip():
	return config.host_ip

func get_config_port():
	return config.host_port

func get_config_host_model():
	return config.host_model
	
func config_exists():
	return FileAccess.file_exists(CONFIG_FILE_PATH)

func save_config():
	ResourceSaver.save(config, CONFIG_FILE_PATH)

func load_config():
	config = ResourceLoader.load(CONFIG_FILE_PATH, "Config", ResourceLoader.CACHE_MODE_IGNORE)
