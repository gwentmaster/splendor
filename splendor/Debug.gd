extends ScrollContainer
class_name Debug


func debug(s: String) -> void:
	
	var label = Label.new()
	label.text = s
	$VBoxContainer.add_child(label)
