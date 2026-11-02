extends Control

@export var fondo_negro: ColorRect
@export var texto_aviso: Label
@export var segundos_espera := 3.0
@export var mensaje := "¡Prepárate!"

var cargando := false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if fondo_negro:
		fondo_negro.hide()

func _on_boton_jugar_pressed():
	if cargando:
		return
	cargando = true

	if fondo_negro:
		if texto_aviso:
			texto_aviso.text = mensaje
		fondo_negro.modulate.a = 0.0
		fondo_negro.show()
		create_tween().tween_property(fondo_negro, "modulate:a", 1.0, 0.5)

	await get_tree().create_timer(segundos_espera).timeout
	get_tree().change_scene_to_file("res://Entrenamiento.tscn")



func _on_war_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://Entrenamiento.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()
