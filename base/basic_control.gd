class_name BasicControl extends Control

## Connection mapping for extended nodes to simplify connecting lots of elements
var connection_map: Array[Array]

## Automatically called on scene removal, disconnects signals and free's memory
func _exit_tree()->void:
	SignalBus.disconnect_signals(connection_map)
	queue_free()

## Used for instanciated subscenes like lists of instances
func remove_node()->void:
	SignalBus.disconnect_signals(connection_map)
	get_parent().remove_child(self)
	queue_free()

func connect_signals()->void:
	SignalBus.connect_signals(connection_map)

func connect_signal(new_signal: Signal, method:Callable)->void:
	connection_map.append([new_signal, method])
	SignalBus.connect_signal(new_signal, method)

func disconnect_signals()->void:
	SignalBus.disconnect_signals(connection_map)

func hide_children_of(node:Node)->void:
	for child in node.get_children():
		child.hide()

func remove_children_of(node:Node)->void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
