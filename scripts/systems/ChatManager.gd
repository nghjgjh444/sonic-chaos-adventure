# ChatManager.gd
# Manages multiplayer chat system

extends Node

class ChatMessage:
	var sender_name: String
	var sender_id: int
	var content: String
	var timestamp: float
	
	func _init(name: String, id: int, msg: String) -> void:
		sender_name = name
		sender_id = id
		content = msg
		timestamp = OS.get_ticks_msec() / 1000.0

var chat_messages = []
var last_message_time = 0.0
var cooldown_active = false

signal message_sent(message)
signal message_received(message)

func _ready():
	set_name("ChatManager")

func send_message(player_name: String, player_id: int, message: String) -> bool:
	# Validate message
	if message.strip_edges().empty():
		return false
	
	if message.length() > GameConstants.MAX_CHAT_MESSAGE_LENGTH:
		message = message.substr(0, GameConstants.MAX_CHAT_MESSAGE_LENGTH)
	
	# Check cooldown
	if cooldown_active:
		return false
	
	var msg = ChatMessage.new(player_name, player_id, message)
	chat_messages.append(msg)
	
	# Limit message history
	if chat_messages.size() > GameConstants.CHAT_LOG_SIZE * 2:
		chat_messages.pop_front()
	
	emit_signal("message_sent", msg)
	
	# Start cooldown
	cooldown_active = true
	yield(get_tree(), "idle_frame")
	yield(get_tree().create_timer(GameConstants.CHAT_MESSAGE_COOLDOWN), "timeout")
	cooldown_active = false
	
	return true

func get_recent_messages(count: int = GameConstants.CHAT_LOG_SIZE) -> Array:
	var recent = []
	var start_idx = max(0, chat_messages.size() - count)
	for i in range(start_idx, chat_messages.size()):
		recent.append(chat_messages[i])
	return recent

func clear_messages() -> void:
	chat_messages.clear()
