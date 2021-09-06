extends ScrollContainer
class_name Log


export (PackedScene) var Message


onready var scrollbar = self.get_v_scrollbar()


func reset() -> void:
	
	for msg in $MessageBox.get_children():
		$MessageBox.remove_child(msg)
		msg.free()


func append_message(data: Dictionary) -> void:
	print(data)
	
	var container = Container.new()
	container.rect_min_size = Vector2(800, 200)
	container.add_child(Message.instance().set_message(data["action"], data))
	$MessageBox.add_child(container)
	
#	$MessageBox.add_child(Message.instance().set_message(data["action"], data))
	self.scroll_vertical = scrollbar.max_value
