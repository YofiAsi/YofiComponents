class_name Movement2D
extends Node2D

@onready var parent: Node2D = self.get_parent()

@export_range(0, 1000, 0.2) var BASE_ACCELERATION: float = 500.0
@export_range(0, 1000, 0.2) var BASE_DECELERATION: float = 1000.0
@export_range(0, 1000, 0.2) var BASE_TURN_SPEED: float = 2500.0
