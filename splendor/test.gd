extends Control


var Gem = load("res://Gem/Gem.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var gold = Gem.instance().set_color("gold")
	gold.scale = Vector2(0.1, 0.1)
	gold.position = Vector2(100, 100)
	
	$PurchaseButton.add_child(gold)
	
	# for i in range(5):
	# 	var blue = Gem.instance().set_color("blue")
	# 	blue.scale = Vector2(0.1, 0.1)
	
	# 	$PurchaseButton.add_child(blue)
	
	# print($PurchaseButton.get_child_count())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
