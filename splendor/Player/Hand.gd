extends Panel
class_name Hand


export var gem_num = {"blue": 0, "brown": 0, "green": 0, "gold": 0, "red": 0, "white": 0}
export var card_num = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
export var reserved_cards = []
export var score = 0


export (PackedScene) var Card


func _ready():
	gem_num["gold"] = 8
	card_num["brown"] = 10
	refresh_gem_num()
	refresh_card_num()
	
	$ReservedCard/Slot0.set_card("senior", 12)
	get_tree().call_group("cards", "check_price", card_num, gem_num)


func arrange_reserved_card() -> void:
	for i in range(len(reserved_cards)):
		$ReservedCard.get_node("Slot" + str(i)).set_card(reserved_cards[i][0], reserved_cards[i][1]).set_selectable(true)
	for i in range(len(reserved_cards), 3):
		var card = $ReservedCard.get_node("Slot" + str(i))
		card.get_node("CardButton/Image").texture = null
		card.set_selectable(false)
	

func reserve_card(level: String, serial_number: int, with_gold: bool) -> void:
	# 保留卡牌
	# Args:
	#     level: 卡牌所属分类, 可为"senior", "junior", "primary"
	#     serial_number: 卡牌序号
	#     with_gold: 此次保留能否获得黄金
	
	reserved_cards.append([level, serial_number])
	if len(reserved_cards) == 3:
		get_tree().call_group("cards", "set_reservable", false)
	arrange_reserved_card()
	$ReservedCard/ReservedCardCounter.text = str(len(reserved_cards)) + "/3"
	
	if with_gold == true:
		gain_gem({"gold": 1})
	
	
func purchase_card(cost: Dictionary, card_score: int, color: String) -> void:
	# 从`CardBank`购买卡牌
	# Args:
	#     cost: 购买卡牌需花费的宝石, 以宝石颜色(含"gold")为键, 数目为值的字典
	#     card_score: 卡牌分数
	#     color: 卡牌颜色
	
	pay_gem(cost)
	score += card_score
	$Score.text = str(score)
	card_num[color] += 1
	refresh_card_num()
	
	
func purchase_reserved_card(slot: int) -> void:
	# 从保留卡中购买
	# Args:
	#     slot: 卡牌对应槽位
	
	var card: Card = $ReservedCard.get_node("Slot" + str(slot))
	pay_gem(card.actual_cost)
	score += card.score
	$Score.text = str(score)
	card_num[card.color] += 1
	refresh_card_num()
	
	reserved_cards.erase([card.level, card.serial_number])
	arrange_reserved_card()
	
	
func refresh_gem_num() -> void:
	# 刷新标签所显示的宝石数目
	
	for key in gem_num.keys():
		$Resource.get_node(key.capitalize()).get_node("GemCounter").text = str(gem_num[key])
		
		
func refresh_card_num() -> void:
	# 刷新标签所显示的卡牌数目
	
	for key in card_num.keys():
		$Resource.get_node(key.capitalize()).get_node("CardCounter").text = str(card_num[key])


func pay_gem(price: Dictionary) -> void:
	# 花费宝石
	# Args:
	#     price: 宝石颜色为键, 数目为值的字典, 代表购买卡牌实际需花费的宝石
	
	for color in price.keys():
		gem_num[color] -= price[color]
	refresh_gem_num()


func gain_gem(gems: Dictionary) -> void:
	# 拿取宝石
	# Args:
	#     gems: 以宝石颜色("blue", "brown"...)为键, 宝石数目为值的字典
	
	for color in gems.keys():
		gem_num[color] += gems[color]
	refresh_gem_num()


func reset():
	# 游戏初始设置
	
	score = 0
	reserved_cards= []
	gem_num = {"blue": 0, "brown": 0, "green": 0, "gold": 0, "red": 0, "white": 0}
	card_num = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
	refresh_gem_num()
	refresh_card_num()
		
		
