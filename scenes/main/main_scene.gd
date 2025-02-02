class_name MaiScene extends BasicControl

enum Scenes {MAIN_MENU, CHAT}

@export var main_menu_scene: PackedScene
@export var chat_container_scene: PackedScene
@export var content: Control

func _ready() -> void:
	SignalBus.change_scene_main_menu.connect(show_mainmenu)
	SignalBus.change_scene_new_chat.connect(show_new_chat)
	SignalBus.change_scene_old_chat.connect(show_old_chat)
	show_mainmenu()

func show_mainmenu():
	var scene = main_menu_scene.instantiate()
	remove_children()
	content.add_child(scene)

func show_new_chat():
	var scene = chat_container_scene.instantiate()
	remove_children()
	content.add_child(scene)

func show_old_chat(_old_chat_name:String):
	var chatData = ResourceLoader.load(App.CHAT_FILE_SAVE_PATH % [_old_chat_name], 'ChatData', ResourceLoader.CACHE_MODE_IGNORE)
	var scene = chat_container_scene.instantiate() as ChatContainer
	scene.chatData = chatData
	remove_children()
	content.add_child(scene)

func remove_children()->void:
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
