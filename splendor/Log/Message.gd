extends Panel
class_name Message


enum CardArea {DECK = 0, BANK = 1, RESERVED = 2}


var CARD_SCALE = Vector2(0.25, 0.25)
var CARD_SCALE_LARGER = Vector2(1.5, 1.5)
var GEM_SCALE = Vector2(0.2, 0.2)
var NOB_SCALE = Vector2(0.15, 0.15)


func set_message(action: String, data: Dictionary):
	
	$PlayerName.text = data["name"]

	# 购买卡牌
	if action == "purchase_card":
		if data["area"] == CardArea.BANK:
			$Action.text = "从仓库购买"
		elif data["area"] == CardArea.RESERVED:
			$Action.text = "从保留卡牌中购买"
			
		var card = TextureRect.new()
		card.texture = load("res://Assets/image/" + data["level"] + "_card/" + str(data["serial_number"]) + ".jpg")
		card.rect_scale = CARD_SCALE
		card.rect_position = Vector2(50, 0)
		card.connect("mouse_entered", self, "_on_card_mouse_entered")
		card.connect("mouse_exited", self, "_on_card_mouse_exited")
		$Panel.add_child(card)

	# 保留卡牌
	elif action == "reserve_card":
		$Action.text = "保留"
		var card = TextureRect.new()
		if data["area"] == CardArea.DECK:
			card.texture = load("res://Assets/image/" + data["level"] + "_card/back.jpg")
		else:
			card.texture = load("res://Assets/image/" + data["level"] + "_card/" + str(data["serial_number"]) + ".jpg")
		card.rect_scale = CARD_SCALE
		card.rect_position = Vector2(50, 0)
		card.connect("mouse_entered", self, "_on_card_mouse_entered")
		card.connect("mouse_exited", self, "_on_card_mouse_exited")
		$Panel.add_child(card)
		
		if data["with_gold"]:
			$Tail.text = "并获得1黄金"
		

	# 拿取宝石
	elif action == "get_gem":
		$Action.text = "拿取"
		var x = 0
		for c in data["gems"].keys():
			if data["gems"][c] == 0:
				continue
			for i in range(data["gems"][c]):
				var gem = TextureRect.new()
				gem.texture = load("res://Assets/image/gem/" + c + ".png")
				gem.rect_scale = GEM_SCALE
				gem.rect_position = Vector2(x, 0)
				$Panel.add_child(gem)
				x += 100

	# 获得贵族
	elif action == "get_nobility":
		$Action.text = "获得贵族"
		var nob = TextureRect.new()
		nob.texture = load("res://Assets/image/nobility/" + str(data["serial_number"]) + ".jpg")
		nob.rect_scale = NOB_SCALE
		$Panel.add_child(nob)
		
	return self


func _on_card_mouse_entered() -> void:
	for card in $Panel.get_children():
		card.rect_scale = CARD_SCALE_LARGER
		break


func _on_card_mouse_exited() -> void:
	for card in $Panel.get_children():
		card.rect_scale = CARD_SCALE
		break
