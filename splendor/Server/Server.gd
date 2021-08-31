extends Node

var _host: String = "fastapi-gogyes.cloud.okteto.net"
var _port: int = 80
var _name: String = ""
var _password: String = ""
var _session: WebSocketClient = WebSocketClient.new()


func connect_server(name: String, password: String, host = null, port = null) -> void:

	if host:
		_host = host
	if port:
		_port = port
	_name = name
	_password = password
	
	var err = _session.connect_to_url("ws://" + _host + ":" + str(_port))
	if err != OK:
		print(err)
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
	var data = parse_json(_session.get_peer(1).get_packet().get_string_from_utf8())

	if data["command"] == 0:  # login
		send_json({"command": 0, "data": {"name": _name, "password": _password}})

	elif data["command"] == 1:  # enter_room
		pass

	elif data["command"] == 2: # create_room
		pass

	elif data["command"] == 3:  # recover
		pass

	elif data["command"] == 4:  # sync
		var game_data = get_tree().call_group_flags(2, "game", "get_game_data")
		send_json({"command": 4, "data": game_data})
		
	elif data["command"] == 5:  # broadcast
		pass
		
	elif data["command"] == 6:  # game_start
		pass
		
	elif data["command"] == 7:  # round_start
		pass
		
	elif data["command"] == 8:  # game_end
		pass


func _process(delta: float) -> void:
	_session.poll()
