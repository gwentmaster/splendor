extends Panel


var nick_name: String = ""
var id: String = ""


var card_num: Dictionary = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var gem_num: Dictionary = {"blue": 0, "brown": 0, "gold": 0, "green": 0, "red": 0, "white": 0}
var score: int = 0


func refresh_card_num() -> void:
	for color in card_num.keys():
		get_node(color.capitalize() + "Area/CardCounter").text = str(card_num[color])
		
		
func refresh_gem_num() -> void:
	var gem_summary = 0
	for color in gem_num.keys():
		get_node(color.capitalize() + "Area/GemCounter").text = str(gem_num[color])
		gem_summary += gem_num[color]
	$GemSummary.text = str(gem_summary) + "/10"
	
	
func set_name(name: String) -> void:
	self.add_to_group("player_" + name)
	nick_name = name
	$Name.test = name
	
	
func set_score(s: int) -> void:
	score = s
	$Score.text = str(s)
