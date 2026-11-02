extends StaticBody2D

@export var tiempo_vida := 5.0   # segundos antes de que escape

func _ready():
	input_pickable = true
	var reloj = Timer.new()
	reloj.wait_time = tiempo_vida
	reloj.one_shot = true
	reloj.autostart = true
	reloj.timeout.connect(_escapar)
	add_child(reloj)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().call_group("contador", "sumar_objetivo")
		_explotar()
		queue_free()

func _escapar():
	get_tree().call_group("contador", "objetivo_escapo")
	input_pickable = false
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	t.tween_callback(queue_free)

func _explotar():
	var p = CPUParticles2D.new()
	get_parent().add_child(p)
	p.global_position = global_position
	p.z_index = 10
	p.one_shot = true
	p.explosiveness = 1.0
	p.amount = 25
	p.lifetime = 0.7
	p.direction = Vector2.UP
	p.spread = 180.0
	p.initial_velocity_min = 100.0
	p.initial_velocity_max = 250.0
	p.gravity = Vector2(0, 500)
	p.angular_velocity_min = -360.0
	p.angular_velocity_max = 360.0
	p.scale_amount_min = 4.0
	p.scale_amount_max = 8.0
	p.color = Color(0.55, 0.3, 0.1)
	p.emitting = true
	get_tree().create_timer(p.lifetime + 0.2).timeout.connect(p.queue_free)
