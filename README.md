# README.md
# SONIC: CHAOS ADVENTURE

A full-featured 2D Top-Down Action RPG built with **Godot Engine 3.6**.

## Features

### Gameplay
- **6 Playable Characters** with unique abilities
- **5 Game Zones** with distinct environments
- **Fast-paced Action** with Spindash, Boost, Homing Attack
- **Ring Collection & Power-ups**
- **Boss Encounters & Enemy AI**
- **Chaos Emeralds** progression system
- **Character Unlock System** (Shadow, Metal Sonic, Silver)

### Characters
1. **Sonic** - Balanced hero with Spindash
2. **Tails** - Flight ability
3. **Knuckles** - Glide & Climb abilities
4. **Shadow** (Secret) - Chaos Control
5. **Metal Sonic** (Secret) - Overdrive mode
6. **Silver** (Secret) - Psychokinesis

### Zones
1. Green Hill Zone
2. Chemical Zone
3. Sandopolis Zone
4. Emerald Coast Zone
5. City Escape Zone

### Game Modes
- **Singleplayer** - Complete levels as one character
- **Local Multiplayer** - Up to 4 players on same screen
- **Network Multiplayer** - Online co-op (via ENet)
- **In-Game Chat** - Local and Network multiplayer chat

### Systems
- **Health & Shield System**
- **Boost Energy Management**
- **Checkpoint Save System**
- **Game Save/Load**
- **Audio Manager** (BGM + SFX)
- **Character Progression**
- **HUD with Real-time Stats**

## Project Structure

```
res://
├── scenes/
│   ├── menus/          # UI Menus
│   ├── levels/         # Game Zones
│   ├── player/         # Character scenes
│   ├── enemies/        # Enemy types
│   └── objects/        # Game objects (rings, springs, etc)
├── scripts/
│   ├── systems/        # Core managers
│   ├── characters/     # Character implementations
│   ├── enemies/        # Enemy AI
│   ├── objects/        # Object scripts
│   ├── levels/         # Level managers
│   ├── ui/            # UI controllers
│   ├── menus/         # Menu logic
│   └── constants/     # Game constants
├── art/                # Sprites & assets
├── audio/              # Music & SFX
└── data/               # Game data files
```

## Controls

### Movement & Actions
- **WASD / Arrow Keys** - Movement
- **Space** - Jump
- **Shift** - Boost
- **E** - Homing Attack
- **Q** - Spindash
- **F** - Character Ability
- **Enter** - Interact
- **T** - Chat (Multiplayer)
- **ESC** - Pause

## Getting Started

1. Open project in **Godot Engine 3.6**
2. Run MainMenu scene: `scenes/menus/MainMenu.tscn`
3. Select Character and Zone
4. Play!

## Development Notes

### Godot 3.6 Compatibility
- Uses `KinematicBody2D` (not CharacterBody2D)
- Uses `AnimatedSprite` (not Sprite2D)
- Uses GDScript 3.6 syntax
- Network uses `NetworkedMultiplayerENet`
- RPC system for multiplayer sync

### AI Systems
- Enemy patrol and chase mechanics
- Target detection and adaptation
- Configurable behavior per enemy type

### Multiplayer Architecture
- Local split-screen camera
- Network RPC-based synchronization
- In-game chat with cooldown protection
- Player state management

## Future Enhancements

- Boss battles
- Additional character abilities
- More enemy types
- Level customization
- Achievements/Leaderboards
- Mobile support

## License

This project is for educational purposes.

---

**Created with ❤️ for Sonic fans using Godot Engine 3.6**
