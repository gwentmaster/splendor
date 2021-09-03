extends Panel


func _on_ConnectButton_pressed():
	$Server.connect_server(
		$NameEditor/LineEdit.text,
		$PasswordEditor/LineEdit.text,
		$HostEditor/LineEdit.text,
		int($PortEditor/LineEdit.text)
	)
