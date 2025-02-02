extends BasicControl

@export var api_generate_url = "/api/generate" # generate a response
@export var api_tags = "/api/tags" # list available models
@export var api_version = "/api/version" # list available models

var header = ["Content-Type: application/json"]
func _ready():
	IP.resolve_hostname(create_domain(), IP.TYPE_IPV4)

func create_domain()->String:
	return App.get_host_protocol() + App.get_config_ip() + ':' + App.get_config_port()



func get_available_models() -> Array:
	return []
