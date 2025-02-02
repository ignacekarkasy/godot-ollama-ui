extends AcceptDialog
@export var option_button: OptionButton
@export var ip: LineEdit
@export var port: LineEdit
@export var default_model: OptionButton
@export var test: Button
var test_ok: bool = false
var get_version_request: HTTPRequest
var get_models_request: HTTPRequest
@export var test_result: Label
@export var load_models: Button
@export var current_default_model: Label
@export var languages: OptionButton

func _ready():
	get_version_request = HTTPRequest.new()
	get_version_request.set_timeout(1.0)
	get_version_request.request_completed.connect(_on_version_request_complete)
	add_child(get_version_request)
	
	get_models_request = HTTPRequest.new()
	get_models_request.set_timeout(1.0)
	get_models_request.request_completed.connect(_on_load_models_complete)
	add_child(get_models_request)
	
	for protocol in Config.Protocol:
		option_button.add_item(protocol)
	
	for language in Config.Language:
		languages.add_item(language)
	
	option_button.selected = App.get_config_protocol()
	ip.text = App.get_config_ip()
	port.text = App.get_config_port()
	default_model.text = App.get_config_host_model()
	test.pressed.connect(test_connection)
	load_models.pressed.connect(_on_load_models)
	default_model.item_selected.connect(_on_default_model_selected)
	option_button.item_selected.connect(_on_host_protocol)
	ip.text_changed.connect(_on_ip_changed)
	port.text_changed.connect(_on_port_changed)
	languages.item_selected.connect(_on_language_changed)
	update_default_model_label()

func _on_language_changed(idx:int):
	App.change_language(idx)
	
func _on_ip_changed(new_ip:String):
	App.change_host_ip(new_ip)

func _on_port_changed(new_port:String):
	App.change_host_port(new_port)

func _on_host_protocol(idx:int):
	App.change_host_protocol(idx)

func update_default_model_label():
	current_default_model.text = App.get_config_host_model()

func _on_default_model_selected(idx: int):
	var new_model_name = default_model.get_item_text(idx)
	App.change_default_model(new_model_name)
	update_default_model_label()
	

func _on_load_models():
	get_models_request.request(
		App.get_tags_url(), 
		App.get_ollama_header(), 
		HTTPClient.METHOD_GET
	)
	
func test_connection():
	load_models.disabled = true
	default_model.disabled = true
	print(App.get_version_url(), App.get_ollama_header())
	get_version_request.request(
		App.get_version_url(), 
		App.get_ollama_header(), 
		HTTPClient.METHOD_GET
	)

func _on_version_request_complete(result, response, _headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		test_result.text = tr("TEST FAILED")
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	if not json:
		test_result.text = tr("JSON FAILED")
		return
	load_models.disabled = response != 200
	test_result.text = json["version"]

func _on_load_models_complete(_result, response, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if not json:
		return
	default_model.disabled = response != 200
	var i = 0
	for model in json["models"]:
		default_model.add_item(model["model"])
		if model["model"] == App.get_config_host_model():
			default_model.selected = i
		i += 1
