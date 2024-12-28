class_name Movement2D extends Node2D

@export_range(0, 9999, 0.2) var BASE_ACCELERATION: float = 500.0
@export_range(0, 9999, 0.2) var BASE_DECELERATION: float = 1000.0
@export_range(0, 99999, 0.2) var BASE_TURN_SPEED: float = 2500.0
@export_range(0, 1000, 0.2) var BASE_MAX_SPEED: float = 2500.0

@export var animated_sprite: AnimationManager

enum State {
	IDLE,
	DESTINATION,
	DIRECTION,
}

@onready var parent: Node2D = self.get_parent()

var destination: Vector2:
	get: return destination
	set(value):
		if self.curr_state == State.IDLE:
			if self.animated_sprite:
				self.animated_sprite.play("run")
		self.curr_state = State.DESTINATION
		destination = value
var direction: Vector2:
	get: return direction
	set(value):
		if self.curr_state == State.IDLE:
			if self.animated_sprite:
				self.animated_sprite.play("run")
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
	if self.animated_sprite and self.curr_state != State.IDLE:
		self.animated_sprite.play("idle")
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

	# Adjust acceleration based on turning or linear movement
	var max_speed_change = delta * (
		self.BASE_DECELERATION
		if desired_velocity.is_zero_approx() else
		(
			self.BASE_ACCELERATION
			if (desired_velocity.normalized() - self.velocity.normalized()).is_zero_approx() else
			self.BASE_TURN_SPEED
		)
	)

	# Update velocity without clamping
	self.velocity += (desired_velocity - self.velocity).limit_length(max_speed_change)

	# Decelerate if velocity exceeds BASE_MAX_SPEED
	if self.velocity.length() > self.BASE_MAX_SPEED:
		self.velocity = self.velocity.normalized() * max(
			self.BASE_MAX_SPEED,
			self.velocity.length() - self.BASE_DECELERATION * delta
		)

	# Stop if velocity is nearly zero
	if self.velocity.is_zero_approx():
		self.stop()
		return

	# Move the parent
	if parent is CharacterBody2D:
		parent.velocity = self.velocity
		parent.move_and_slide()
		return

	self.move(delta)


func knock_back(force: float):
	self.velocity -= self.velocity.normalized() * force

func dash(dash_speed: float, direction: Vector2 = Vector2.ZERO) -> void:
	self.velocity += (direction if direction != Vector2.ZERO else self.velocity.normalized()) * dash_speed


func add_force(force_direction: Vector2) -> void:
	self.velocity += force_direction
