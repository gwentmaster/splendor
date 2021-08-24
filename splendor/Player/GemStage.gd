extends Panel
class_name GemStage


export (PackedScene) var Gem


func _ready():
	pass


func add_gem(color: String) -> void:
	# 向暂存区添加1个宝石
	# Args:
	#     color: 宝石的颜色

	# 已拿满3个宝石, 则不能再拿	
	var children = $Gems.get_children()
	if len(children) == 2:
		get_tree().call_group("gem_bank", "set_enable", "all", false)
	
	# 调整已拿取宝石的位置, 并检查是否拿取2个同种宝石, 是则不能再拿
	var middle = (len(children) + 1) / 2
	var pad = 1 - (len(children) + 1) % 2
	for i in range(len(children)):
		children[i].position = Vector2(800 + (i + 0.5*pad - middle)*500, 450)
		if children[i].color == color:
			get_tree().call_group("gem_bank", "set_enable", "all", false)
	
	# 显示新拿取的宝石
	var gem = Gem.instance().set_color(color)
	gem.position = Vector2(800 + (len(children) + 0.5*pad - middle)*500, 450)
	$Gems.add_child(gem)



func _on_CancelButton_pressed():
	for child in $Gems.get_children():
		child.get_parent().remove_child(child)
		get_tree().call_group("gem_bank", "gain_gem", child.color, 1)
		get_tree().call_group("gem_bank", "set_enable", "all", true)
		child.free()


func _on_ConfirmButton_pressed():
	pass # Replace with function body.
