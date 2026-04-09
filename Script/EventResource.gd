extends Resource
class_name EventResource

@export var event_name: String = ""
@export var description: String = ""
@export var event_type: String = ""      # 如 "stat_change", "add_item", "start_battle"
@export var stat_name: String = ""       # 如 "health", "gold"
@export var stat_value: int = 0
