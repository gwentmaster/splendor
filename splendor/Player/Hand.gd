extends Panel


export var gem_num = {"blue": 0, "brown": 0, "green": 0, "gold": 0, "red": 0, "white": 0}
export var card_num = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
export var reserved_cards = []
export var score = 0


export (PackedScene) var Card


func _ready():
	gem_num["gold"] = 12
	card_num["brown"] = 10
	refresh_gem_num()
	refresh_card_num()
	print($ReservedCard/Card0.scale)
	
	$ReservedCard/Card0.set_card("senior", 12)
	

func reserve_card(card):
	reserved_cards.append(card)
	pass  # 卡图
	$ReservedCardCounter.text = str(len(reserved_cards)) + "/3"
	
	
func refresh_gem_num():
	for key in gem_num.keys():
		$Resource.get_node(key.capitalize()).get_node("GemCounter").text = str(gem_num[key])
		
		
func refresh_card_num():
	for key in card_num.keys():
		$Resource.get_node(key.capitalize()).get_node("CardCounter").text = str(card_num[key])

func pay_gem(price):
	for color in price.keys():
		gem_num[color] -= price[color]
	refresh_gem_num()


func gain_gem(gems):
	for color in gems.keys():
		gem_num[color] += gems[color]
	refresh_gem_num()
	

func gain_card(card):
	score += card.score
	$Score.text = str(score)
	card_num[card.color] += 1
	refresh_card_num()


func reset():
	score = 0
	reserved_cards= []
	gem_num = {"blue": 0, "brown": 0, "green": 0, "gold": 0, "red": 0, "white": 0}
	card_num = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
	refresh_gem_num()
	refresh_card_num()
		
		
