extends Control


func _ready():
	var f: float = 12
	is_int(f)


func is_int(num: int) -> void:
	print(typeof(num) == TYPE_INT)
