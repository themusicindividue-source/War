extends CanvasLayer

@export var tiempo_total := 30.0
@export var escapes_maximos := 5
@export var spawner: Node
@export var boton_reiniciar: Button
@export var boton_siguiente: Button
@export_file("node_2d.tscn") var siguiente_nivel := "node_2d"
@onready var etiqueta_tiempo = $EtiquetaTiempo
@onready var etiqueta_mensaje = $EtiquetaMensaje

var tiempo_restante := 0.0
var escapados := 0
var terminado := false

func _ready():
	if boton_siguiente:
		boton_siguiente.hide()
		boton_siguiente.pressed.connect(_siguiente)
	add_to_group("contador")
	tiempo_restante = tiempo_total
	etiqueta_mensaje.hide()
	if boton_reiniciar:
		boton_reiniciar.hide()
		boton_reiniciar.pressed.connect(_reiniciar)

func _process(delta):
	if terminado:
		return
	tiempo_restante -= delta
	etiqueta_tiempo.text = str(int(ceil(tiempo_restante)))
	if tiempo_restante <= 0:
		_terminar(true)

func sumar_objetivo():
	pass

func objetivo_escapo():
	if terminado:
		return
	escapados += 1
	if escapados >= escapes_maximos:
		_terminar(false)

func _terminar(gano: bool):
	if gano:
		etiqueta_tiempo.text = "0"
		etiqueta_mensaje.text = "¡Ganaste!"
		if boton_siguiente and siguiente_nivel != "":
			boton_siguiente.show()
	terminado = true
	if gano:
		etiqueta_tiempo.text = "0"
		etiqueta_mensaje.text = "¡Ganaste!"
	else:
		etiqueta_mensaje.text = "¡Perdiste!"
	etiqueta_mensaje.show()
	_detener_spawner()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if boton_reiniciar:
		boton_reiniciar.show()

func _reiniciar():
	get_tree().reload_current_scene()

func _detener_spawner():
	if is_instance_valid(spawner):
		spawner.queue_free()
	else:
		for nodo in get_tree().root.find_children("*", "Node2D", true, false):
			if nodo.get_script() and "escena_objetivo" in nodo:
				nodo.queue_free()

func _siguiente():
	print("Cambiando a: ", siguiente_nivel)
	get_tree().change_scene_to_file(siguiente_nivel)
