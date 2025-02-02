class_name Config extends Resource

enum Protocol { HTTP, HTTPS }
enum Language { ENGLISH, GERMAN }
var protocol_map = {
	Protocol.HTTP: "http://",
	Protocol.HTTPS: "https://",
}
var language_map = {
	Language.ENGLISH: "en",
	Language.GERMAN: "de",
}
@export var language: Language = Language.ENGLISH
@export var host_protocol: Protocol = Protocol.HTTP
@export var host_ip: String = "127.0.0.1"
@export var host_port: String = "11434"
@export var host_model: String = "deepseek-r1:1.5b"

var api_generate_url = "/api/generate" # generate a response
var api_tags = "/api/tags" # list available models
var api_version = "/api/version" # returns ollama version
var header = ["Content-Type: application/json"]
