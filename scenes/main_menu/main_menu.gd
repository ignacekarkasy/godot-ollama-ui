extends BasicControl
@export var continue_chat: Button
@export var new_chat: Button
@export var about: Button
@export var settings: Button
@export var quit: Button
@export var settings_dialog: AcceptDialog
@export var option_button: OptionButton
@export var load_chat_dialog: ConfirmationDialog

func _ready():
	quit.pressed.connect(_on_quit_pressed)
	settings.pressed.connect(settings_dialog.show)
	new_chat.pressed.connect(SignalBus.change_scene_new_chat.emit)
	option_button.add_item("SELECT CHAT", -1)
	for file in DirAccess.get_files_at(App.CHAT_SAVE_PATH):
		option_button.add_item(file.replace('.tres', ''))
	continue_chat.pressed.connect(load_chat_dialog.show)
	load_chat_dialog.confirmed.connect(_on_load_chat_confirm)

func _on_load_chat_confirm():
	if option_button.selected == -1:
		return
	var chat_name = option_button.get_item_text(option_button.selected)
	SignalBus.change_scene_old_chat.emit(chat_name)

func _on_quit_pressed():
	get_tree().quit()
