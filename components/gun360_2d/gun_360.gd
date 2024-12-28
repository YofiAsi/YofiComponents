class_name Gun360 extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var firerate_timer: Timer = $FirerateTimer
@onready var hit_box: Area2D = $HitBox
@onready var hit_box_collision: CollisionShape2D = $HitBox/CollisionShape2D
@onready var hitbox_disable_timer: Timer = $HitboxDisableTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var radius: float = 40:
	set(value):
		if sprite:
			sprite.position = Vector2(value, 0)
			animated_sprite.position = Vector2(self.radius, 0)
		radius = value
@export var active: bool = true
@export var dmg: int = 10
@export var knockback_force: float = 100.0

func _ready() -> void:
	hit_box_collision.disabled = false
	sprite.position = Vector2(self.radius, 0)
	animated_sprite.position = Vector2(self.radius, 0)
	
func fire() -> void:
	#hit_box_collision.disabled = false
	firerate_timer.start()
	hitbox_disable_timer.start()
	animated_sprite.play()
	
	if not hit_box_collision.disabled:
		for area in hit_box.get_overlapping_areas():
			if not area is Hurtbox2D:
				continue
			if area.is_in_group("player"):
				continue
			var hurtbox_2d: Hurtbox2D = area
			hurtbox_2d.hurt(self.dmg, knockback_force)

func _process(delta: float) -> void:
	if not self.active:
		return
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	self.look_at(mouse_pos)
	
	if not Input.is_action_pressed("shoot"):
		return
	
	if not firerate_timer.is_stopped():
		return
	
	self.fire()

func disable() -> void:
	self.active = false
	self.hide()
	
func enable() -> void:
	self.active = true
	self.show()

func _on_hitbox_disable_timer_timeout() -> void:
	#hit_box_collision.disabled = true
	pass
