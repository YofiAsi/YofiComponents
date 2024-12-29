class_name Hurtbox2D extends Area2D

signal hurt_signal
signal death_signal

@onready var collision: CollisionShape2D = $CollisionShape2D

@export var BASE_MAX_HP: int = 100
@export var movement_2d: Movement2D

var curr_hp: int:
	set(value):
		curr_hp = value
		if curr_hp > 0:
			return
		self.zero_hp()

func zero_hp() -> void:
	self.death()

func death() -> void:
	collision.disabled = true
	death_signal.emit()

func hurt(dmg: int, knockback_force: float):
	curr_hp -= dmg
	
	if self.movement_2d:
		movement_2d.knock_back(knockback_force)
		
	hurt_signal.emit()

func _ready() -> void:
	self.curr_hp = BASE_MAX_HP
