extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "192.168.0.19"
var port = 1911


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
	GameServerHub.ReceiveLoginToken(token)
