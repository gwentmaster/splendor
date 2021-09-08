extends Control


func _ready():
	var f: float = 12
	is_int(f)
	
	var dic = parse_json("""{"hello": 12}""")
	print(dic)
	print(typeof(dic["hello"]) == TYPE_INT)
	print(typeof(dic["hello"]))


func is_int(num: int) -> void:
	print(typeof(num) == TYPE_INT)
