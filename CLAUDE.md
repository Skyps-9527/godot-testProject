# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Godot 4.6 2D side-scrolling roguelike survival game. The player moves, rolls to dodge, and automatically fires bullets at enemies that spawn from the right side of the screen.

## Development

- Open `project.godot` in Godot 4.6 editor (Forward Plus renderer) to edit scenes, run, and debug.
- Export targets: Windows Desktop (`Build/Windows/test.exe`) and Web (`Build/Web/test.exe.html`).
- No CLI build/test commands — everything goes through the Godot editor.

## Input Map

| Action   | Keys       |
|----------|------------|
| Left     | A          |
| Right    | D          |
| Up       | W          |
| Down     | S          |
| Roll     | Space      |

## Architecture

### Scene tree (at runtime, from `Game.tscn`)

```
Node2D (GameManager.gd)          — main controller, enemy spawning, score, pause, event loading
├── Background sprites
├── Camera2D
├── Player (player.gd)           — CharacterBody2D, handles input/movement/fire/roll
├── Boundary / StaticBody2D      — world boundaries
├── SlimeTimer                    — spawns slimes at decreasing intervals (clamped 1–3s)
├── OrcTimer                      — spawns orcs when score > 20
├── CanvasLayer                   — UI: score label, game over label, pause/play buttons
└── Rouge                        — roguelike upgrade panel (visible when skill_score ≥ 10)
```

`bgm.tscn` is auto-loaded as singleton `Bgm`, so background music persists across scene reloads.

### Key scripts

| Script | Node type | Purpose |
|--------|-----------|---------|
| `GameManager.gd` | Node2D | Spawns enemies via timers, tracks `score` and `skill_score`, loads events from `res://Event/` |
| `player.gd` | CharacterBody2D | WASD movement, roll (space), auto-fires when stationary, triggers `game_over()` on enemy contact |
| `bullet.gd` | Area2D | Moves right, self-destructs after 3s |
| `slime.gd` | Area2D | Moves left, 1 HP, killed by any bullet, grants +1 score |
| `orc.gd` | Area2D | Moves left, 2 HP, hit-stun mechanic (0.25s freeze on first hit), grants +2 score on kill |
| `EventResource.gd` | Resource | Custom Resource class with fields: `event_name`, `description`, `event_type`, `stat_name`, `stat_value`, `event_icon` |

### Roguelike upgrade system

Every 10 kills (`skill_score >= 10`), the `Rouge` panel becomes visible. The player chooses from 3 random `EventResource` .tres files loaded from `res://Event/`.

Existing events:
- `SpeedUp.tres` — +2 move speed
- `BulletUp.tres` — +1 bullet count
- `RollSpeedUp.tres` — +10 roll speed

### Enemy spawning

- Slimes spawn continuously; spawn timer accelerates each frame until clamped to [1s, 3s].
- Orcs start spawning when score exceeds 20.
- Enemies are destroyed when they move past `x < -260`.

### Scene reload

On game over, after a timer delay, the game calls `get_tree().reload_current_scene()` — all state is reset by the scene reload.

## Project conventions

- Scripts and scenes are in Chinese for display text (event names, descriptions).
- Source files use UTF-8 encoding (per `.editorconfig`).
- `.godot/`, `/android/`, `.idea` are git-ignored.
