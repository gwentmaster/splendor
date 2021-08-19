extends Area2D


# 标志属于何种宝石, 共有"blue", "brown", "gold", "green",
# "red", "white"等种类
export var color = "red"

var IMAGE_PATH = "res://Assets/image/gem/"


func set_color(color_string):
	
	color = color_string
	$Sprite.texture = load(IMAGE_PATH + color_string + ".png")
	return self
	
	
func set_label(label):
	
	$Label.text = label
