extends Area2D
class_name Gem


signal pressed (color)


# 标志属于何种宝石, 共有"blue", "brown", "gold", "green",
# "red", "white"等种类
export var color = "red"

var IMAGE_PATH = "res://Assets/image/gem/"


func set_color(color_string: String) -> Gem:
	
	color = color_string
	$TextureRect.texture = load(IMAGE_PATH + color_string + ".png")
	return self


func set_label(label: String) -> Gem:
	
	$Label.text = label
	return self


func _on_TextureRect_gui_input(event: InputEvent) -> void:
	"""点击时发出信号"""

	if (
		event is InputEventMouse
		and event.is_pressed()
		and event.button_index == BUTTON_LEFT
	):
		emit_signal("pressed", self.color)
