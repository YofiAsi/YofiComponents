##@tool
class_name PlayerControl2D extends Node2D
#
@export var movement_control: Movement2D:
	get():
		return movement_control
	set(value):
		movement_control = value
		if Engine.is_editor_hint():
			self.update_configuration_warnings()

var last_vertical_pressed: int = 0
var last_horizontal_pressed: int = 0

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	
	if not self.movement_control:
		warnings.append("Movement2D node has not been assigned")

	return warnings

func get_desired_direction() -> Vector2:
	var desired_direction = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
		)
	
	if Input.is_action_just_pressed("right"):
		self.last_horizontal_pressed = 1
	if Input.is_action_just_pressed("left"):
		self.last_horizontal_pressed = -1
	if Input.is_action_just_pressed("up"):
		self.last_vertical_pressed = -1
	if Input.is_action_just_pressed("down"):
		self.last_vertical_pressed = 1
	
	if not desired_direction == Vector2.ZERO:
		return desired_direction.normalized()
	
	if Input.is_action_pressed("right"):
		desired_direction += Vector2(self.last_horizontal_pressed, 0)
	if Input.is_action_pressed("up"):
		desired_direction += Vector2(0, self.last_vertical_pressed)
		
	return desired_direction.normalized()
	

func _physics_process(delta: float) -> void:
	if not movement_control:
		return
	if Input.is_action_just_pressed("stop"):
		movement_control.stop()
		return
	
	var desired_direction = self.get_desired_direction()
	movement_control.move_direction(desired_direction)
