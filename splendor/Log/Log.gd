extends ScrollContainer
class_name Log


export (PackedScene) var Message


func reset() -> void:
	
	for msg in $MessageBox.get_children():
		$MessageBox.remove_child(msg)
		msg.free()


func append_message(data: Dictionary) -> void:
	
	var container = Container.new()
	container.rect_min_size = Vector2(800, 200)
	container.add_child(Message.instance().set_message(data["action"], data))
	
	var children = $MessageBox.get_children()
	for child in children:
		$MessageBox.remove_child(child)
	$MessageBox.add_child(container)
	for child in children:
		$MessageBox.add_child(child)
