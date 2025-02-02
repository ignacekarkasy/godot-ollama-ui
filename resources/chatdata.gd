class_name ChatData extends Resource

@export var model: String = App.get_config_host_model()
var prompt: String = ""
var stream: bool = false
@export var context: Array = []
@export var chat_name: String = ""
@export var messages: Array[Message]
func to_dict()->Dictionary:
	return {
		'model': model,
		'prompt': prompt,
		'stream': stream,
		'context': context,
	}
