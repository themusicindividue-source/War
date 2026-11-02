extends Node2D

@export var escena_objetivo: PackedScene
@export var inicios: Node2D
@export var destinos: Node2D
@export var intervalo := 1.0
@export var duracion_movimiento := 1.0
@export var max_objetivos := 5
@export var cantidad_min := 1
@export var cantidad_max := 3

func _ready():
	if escena_objetivo == null or inicios == null or destinos == null:
		push_error("Falta llenar alguna casilla del Inspector en el Spawner")
		return

	while true:
		await get_tree().create_timer(intervalo).timeout
		_crear_grupo()

func _crear_grupo():
	var puntos_inicio = inicios.get_children()
	var puntos_destino = destinos.get_children()
	if puntos_inicio.is_empty() or puntos_destino.is_empty():
		return

	puntos_destino.shuffle()
	var cantidad = randi_range(cantidad_min, cantidad_max)

	for i in cantidad:
		if get_child_count() >= max_objetivos:
			return
		var destino = puntos_destino[i % puntos_destino.size()]
		_crear_uno(puntos_inicio.pick_random(), destino)

func _crear_uno(inicio: Node2D, destino: Node2D):
	var obj = escena_objetivo.instantiate()
	add_child(obj)
	obj.global_position = inicio.global_position

	var t = obj.create_tween()
	t.tween_property(obj, "global_position", destino.global_position, duracion_movimiento).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
