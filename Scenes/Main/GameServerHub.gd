extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = GlobalData.server_info["GAME_SERVER_HUB"]["PORT"]
var max_players = 100

func _ready():
	StartServer()

func _process(_delta):
	if not self.custom_multiplayer.has_network_peer():
		return;
	self.custom_multiplayer.poll()

func StartServer():
	network.create_server(port, max_players)
	self.custom_multiplayer = gateway_api
	self.custom_multiplayer.root_node = self
	self.custom_multiplayer.network_peer = network
	print("GameServerHub started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(server_id):
	print("Server " + str(server_id) + " Connected")


func _Peer_Disconnected(gameserver_id):
	print("Server " + str(gameserver_id) + " Disconnected")


remote func RegisterGameServer(server_id):
	"""
	Name is something to add in the loadbalancer tutorial
	"""
	GlobalData.gameserverlist["GameServer1"] = server_id
	print(GlobalData.gameserverlist)

func DistributeLoginToken(token):
	var gameserver = "GameServer1" #로드 밸런싱으로 선택하도록 수정 필요
	var gameserver_peer_id = GlobalData.gameserverlist[gameserver]
	rpc_id(gameserver_peer_id, "ReceiveLoginToken", token)
