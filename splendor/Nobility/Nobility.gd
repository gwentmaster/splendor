extends TextureRect
class_name Nobility


var score: int = 0
var cost: Dictionary = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var serial_number: int = -2

var nobility_data_set = load("res://Nobility/NobilityData.gd").new()
var NOBILITY_DATA = nobility_data_set.NOBILITY_DATA
var COST_ORDER = nobility_data_set.COST_ORDER


func set_nobility(number: int) -> Nobility:
	# 设置贵族, 加载卡图及数据
	# Args:
	# 	number: 贵族序号
	# Returns:
	# 	贵族对象自身
	
	self.texture = load("res://Assets/image/nobility/" + str(number) + ".png")
	var data = NOBILITY_DATA[number]
	serial_number = number
	score = data["score"]
	for i in range(len(COST_ORDER)):
		cost[COST_ORDER[i]] = data["cost"][i]
	return self


func set_selectable(flag: bool) -> void:
	"""设置贵族是否可拿取"""
	
	if flag:
		$ConfirmButtom.set_disabled(false)
		$ConfirmButtom.show()
	else:
		$ConfirmButtom.set_disabled(true)
		$ConfirmButtom.hide()


func _on_ConfirmButtom_pressed():
	"""确认按扭被点击, 玩家拿取贵族并结束当前回合"""
	
	var tree = get_tree()
	var data = {
		"action": "get_nobility",
		"score": self.score,
		"serial_number": self.serial_number 
	}
	tree.call_group_flags(2, "hand", "gain_nobility", self.score)
	tree.call_group_flags(2, "nobility_bank", "remove_nobility", self.serial_number)
	tree.call_group_flags(2, "nobility_bank", "set_noticer_visible", false)
	tree.call_group_flags(2, "nobility", "set_selectable", false)
	tree.call_group_flags(2, "log", "append_message", data)
	tree.call_group_flags(
		2,
		"server",
		"send_json",
		{
			"command": 5,
			"data": data
		}
	)
	tree.call_group_flags(2, "server", "send_json", {"command": 8, "data": {}})
