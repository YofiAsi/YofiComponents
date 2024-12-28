class_name Movement2D extends Node2D


@export_range(0, 9999, 0.2) var BASE_ACCELERATION: float = 500.0
@export_range(0, 9999, 0.2) var BASE_DECELERATION: float = 1000.0
@export_range(0, 99999, 0.2) var BASE_TURN_SPEED: float = 2500.0
@export_range(0, 1000, 0.2) var BASE_MAX_SPEED: float = 2500.0

enum State {
	IDLE,
	DESTINATION,
	DIRECTION,
}

@onready var parent: Node2D = self.get_parent()

var destination: Vector2:
	get: return destination
	set(value):
		self.curr_state = State.DESTINATION
		destination = value
var direction: Vector2:
	get: return direction
	set(value):
		self.curr_state = State.DIRECTION
		direction = value
var velocity: Vector2
var curr_state: State

func move(delta: float) -> void:
	parent.position += self.velocity * delta

func move_direction(desired_direction: Vector2) -> void:
	self.direction = desired_direction.normalized()
	
func move_destination(desired_destinetion: Vector2) -> void:
	self.destination = desired_destinetion.normalized()

func stop() -> void:
	self.curr_state = State.IDLE
	self.velocity = Vector2.ZERO
	
func _process(delta: float) -> void:
	if self.curr_state == State.IDLE:
		return
	
	var desired_velocity: Vector2
	
	if self.curr_state == State.DESTINATION:
		desired_velocity = parent.global_position.direction_to(self.destination).normalized()
	
	elif self.curr_state == State.DIRECTION:
		desired_velocity = self.direction
	
	desired_velocity = desired_velocity.normalized() * self.BASE_MAX_SPEED
	
	var max_speed_change = delta * (
		self.BASE_DECELERATION
		if desired_velocity.is_zero_approx() else
		(
			self.BASE_ACCELERATION
			if (desired_velocity.normalized() - self.velocity.normalized()).is_zero_approx() else
			self.BASE_TURN_SPEED
		)
	)

	self.velocity += (desired_velocity - self.velocity).limit_length(max_speed_change)
	self.move(delta)
