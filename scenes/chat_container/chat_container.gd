class_name ChatContainer extends BasicControl

@export var userData : TextEdit
var chatData: ChatData
var header = ["Content-Type: application/json"]
var get_generate_request: HTTPRequest
var context = []
@export var message_container:VBoxContainer

@export var back:Button
@export var save:Button
@export var confirmation_dialog:ConfirmationDialog
@export var chat_name:LineEdit
@export var name_exists:Label

@export var ai_response_style: StyleBoxFlat
@export var human_response_style: StyleBoxFlat

func _ready() -> void:
	if not chatData:
		chatData = ChatData.new()
	chat_name.text = chatData.chat_name
	get_generate_request = HTTPRequest.new()
	get_generate_request.request_completed.connect(_on_generate_request_complete)
	add_child(get_generate_request)
	
	
	for message in chatData.messages:
		add_old_message(message)
	
	back.pressed.connect(SignalBus.change_scene_main_menu.emit)
	save.pressed.connect(_on_save_chat)
	chat_name.text_submitted.connect(_on_set_chat_name)
	confirmation_dialog.confirmed.connect(_on_save_name_confirm)

func _on_set_chat_name(new_name: String):
	if FileAccess.file_exists(App.CHAT_FILE_SAVE_PATH % [new_name]):
		name_exists.show()
		return false
	name_exists.hide()
	return true

func _on_save_name_confirm():
	if not _on_set_chat_name(chat_name.text):
		return
	chatData.chat_name = chat_name.text
	ResourceSaver.save(chatData, App.CHAT_FILE_SAVE_PATH % [chatData.chat_name])

func add_old_message(message:Message):
	var new_text_label = RichTextLabel.new()
	var theme_style = human_response_style if message.from == Message.From.HUMAN else ai_response_style
	new_text_label.add_theme_stylebox_override("normal", theme_style)
	new_text_label.text = message.message
	new_text_label.fit_content = true
	new_text_label.selection_enabled = true
	new_text_label.add_theme_color_override('font_shadow_color', Color.BLACK)
	message_container.add_child(new_text_label)
	
func add_new_message(message:Message):
	add_old_message(message)
	chatData.messages.append(message)
	
func _on_save_chat():
	if not chatData.chat_name:
		confirmation_dialog.show()
		return
	ResourceSaver.save(chatData, App.CHAT_FILE_SAVE_PATH % [chatData.chat_name])

func _on_generate_request_complete(_result, _response, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if not json:
		return
	for con in json["context"]:
		context.append(con)
	chatData.context = context
	var message = Message.new()
	message.from = Message.From.AI
	message.message = json["response"]
	add_new_message(message)

func _input(event: InputEvent)->void:
	if event.is_action_pressed("Send"):
		get_generate_request.cancel_request()
		chatData.prompt = userData.text
		var message = Message.new()
		message.from = Message.From.HUMAN
		message.message = userData.text
		add_new_message(message)
		
		userData.text = ""
		
		get_generate_request.request(
			OllamaApi.create_domain()+OllamaApi.api_generate_url, 
			OllamaApi.header, 
			HTTPClient.METHOD_POST,
			JSON.stringify(chatData.to_dict())
		)
