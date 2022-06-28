extends Node

var network = NetworkedMultiplayerENet.new()
var ip = GlobalData.server_info["AUTHENTICATE"]["IP"]
var port = GlobalData.server_info["AUTHENTICATE"]["PORT"]


func _ready():
	ConnectToServer()


func ConnectToServer():
	network.create_client(ip, port)
	get_tree().network_peer = network
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

	
func _OnConnectionFailed():
	print("Failed to connect to authentication server")


func _OnConnectionSucceeded():
	print("Successfully connected to authentication server")
	rpc_id(1, "RegisterHubServer", network.get_unique_id())


remote func DistributeLoginToken(token):
	get_node("/root/GameServerHub").DistributeLoginToken(token)
