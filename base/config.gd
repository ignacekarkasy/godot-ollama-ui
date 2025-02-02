class_name Config extends Resource

enum Protocol { HTTP, HTTPS }
var protocol_map = {
	Protocol.HTTP: "http://",
	Protocol.HTTPS: "https://",
}
@export var host_protocol: Protocol = Protocol.HTTP
@export var host_ip: String = "127.0.0.1"
@export var host_port: String = "11434"
@export var host_model: String = "deepseek-r1:1.5b"
