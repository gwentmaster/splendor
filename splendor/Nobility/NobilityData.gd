extends Node


# 贵族卡数据, "cost"中对应颜色顺序为"white", "blue", "green", "red", "brown"


export var COST_ORDER = ["white", "blue", "green", "red", "brown"]

export var NOBILITY_DATA = [
	{"score": 3, "cost": [0, 0, 0, 4, 4]},                                                             
	{"score": 3, "cost": [0, 0, 3, 3, 3]},                                                             
	{"score": 3, "cost": [0, 4, 4, 0, 0]},                                                             
	{"score": 3, "cost": [3, 3, 3, 0, 0]},                                                             
	{"score": 3, "cost": [4, 0, 0, 0, 4]},                                                             
	{"score": 3, "cost": [4, 4, 0, 0, 0]},                                                             
	{"score": 3, "cost": [3, 3, 0, 0, 3]},                                                             
	{"score": 3, "cost": [0, 0, 4, 4, 0]},                                                             
	{"score": 3, "cost": [3, 0, 0, 3, 3]},                                                             
	{"score": 3, "cost": [0, 3, 3, 3, 0]}
]
