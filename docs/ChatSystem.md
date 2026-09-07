# ReadmeChat.md
# Chat System Implementation

## Overview

The chat system supports:
- Local multiplayer (split-screen)
- Network multiplayer (ENet)
- Real-time message delivery
- Spam prevention via cooldown
- Message length validation

## Architecture

### ChatManager.gd

Centralized manager handling:
- Message sending/receiving
- Cooldown enforcement
- Message history
- Signal emission for UI updates

### Chat UI

**ChatPanel.tscn**
```
ChatPanel
├── ChatLog (displays messages)
├── ChatInput (LineEdit for typing)
└── SendButton
```

### Usage

```gdscript
# Send message
ChatManager.send_message("Sonic", 1, "Let's go!")

# Get recent messages
var messages = ChatManager.get_recent_messages(10)

# Connect to signals
ChatManager.connect("message_sent", self, "_on_message_sent")
```

### Network Sync (Godot 3.6)

```gdscript
# Host sends to all clients via RPC
rpcunreliable(nameof(receive_chat_message), player_name, message)

# Clients receive and display
remote func receive_chat_message(name: String, msg: String):
    ChatManager.send_message(name, peer_id, msg)
```

### Configuration

In GameConstants.gd:
```gdscript
const MAX_CHAT_MESSAGE_LENGTH = 120
const CHAT_MESSAGE_COOLDOWN = 0.5
const CHAT_LOG_SIZE = 10
```

## Features

✅ Per-player cooldown
✅ Message validation
✅ Auto-trim old messages
✅ Works in local & network multiplayer
✅ Prevents client-side cheating
✅ Compatible with Godot 3.6
