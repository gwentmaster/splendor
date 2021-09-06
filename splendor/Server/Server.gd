extends Node

var _host: String = "fastapi-gogyes.cloud.okteto.net"
var _port: int = 80
var _name: String = ""
var _password: String = ""
var _session: WebSocketClient = WebSocketClient.new()


enum CardArea {DECK = 0, BANK = 1, RESERVED = 2}


func connect_server(name: String, password: String, host = null, port = null) -> void:

	if host:
		_host = host
	if port:
		_port = port
	_name = name
	_password = password
	
	var err = _session.connect_to_url("ws://" + _host + ":" + str(_port))
	if err != OK:
		set_process(false)
	else:
		set_process(true)
		
		
func send_json(data: Dictionary) -> void:
	_session.get_peer(1).put_packet(JSON.print(data).to_utf8())


func _ready():
	_session.connect("connection_closed", self, "_closed")
	_session.connect("connection_error", self, "_closed")
	_session.connect("connection_established", self, "_connected")
	_session.connect("data_received", self, "_on_data")
	_session.connect("connection_closed", self, "_closed")


func _closed(was_clean: bool = false) ->void:
	set_process(false)
	
	
func _connected(proto: String = "") -> void:
	pass

func _on_data() -> void:
	var server_data = parse_json(_session.get_peer(1).get_packet().get_string_from_utf8())
	var command = server_data["command"]
	var data = server_data["data"]
	var tree = get_tree()

	if command == 0:  # login
		send_json({"command": 0, "data": {"name": _name, "password": _password}})

	elif command == 1:  # enter_room
		pass

	elif command == 2: # create_room
		pass

	elif command == 3:  # recover
		pass

	elif command == 4:  # sync
		var game_data = get_tree().call_group_flags(2, "game", "get_game_data")
		send_json({"command": 4, "data": game_data})
		
	elif command == 5:  # broadcast
		var action = data["action"]
		if action == "purchase_card":
			tree.call_group(
				"player_" + data["name"],
				"purchase_card",
				data
			)
			if data["area"] == CardArea.BANK:
				tree.call_group("card_bank", "draw_card", data["level"], data["slot"])
			for c in data["cost"].keys():
				tree.call_group("gem_bank", "gain_gem", c, data["cost"][c])
		elif action == "reserve_card":
			tree.call_group(
				"player_" + data["name"],
				"reserve_card",
				data["level"],
				data["serial_number"],
				data["with_gold"]
			)
			if data["area"] == CardArea.BANK:
				tree.call_group("card_bank", "draw_card", data["level"], data["slot"])
			elif data["area"] == CardArea.DECK:
				tree.call_group("card_bank", "reserve_from_deck", data["level"])
			if data["with_gold"]:
				tree.call_group("gem_bank", "offer_gem", "gold")
		elif action == "get_gem":
			tree.call_group(
				"player_" + data["name"],
				"gain_gem",
				data["gems"]
			)
			for c in data["gems"].keys():
				for i in range(data["gems"][c]):
					tree.call_group_flags(2, "gem_bank", "offer_gem", c)
		elif action == "get_nobility":
			tree.call_group(
				"player_" + data["name"],
				"gain_nobility",
				data["score"]
			)
			tree.call_group(
				"nobility_bank",
				"remove_nobility",
				data["serial_number"]
			)
		
	elif command == 6:  # game_start
		tree.call_group_flags(2, "game", "game_start", data)
		
	elif command == 7:  # round_start
		tree.call_group_flags(2, "game", "round_start")
		
	elif command == 8:  # round_end
		pass
		
	elif command == 9:  # game_end
		pass


func _process(delta: float) -> void:
	_session.poll()
