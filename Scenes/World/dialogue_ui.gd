extends CanvasLayer


@onready var dialogue_box: NinePatchRect = $Control/NinePatchRect
@onready var text_label: RichTextLabel = $Control/NinePatchRect/Margin/RichTextLabel
@onready var dialogue_ui: CanvasLayer = $"."
signal dialogue_finished
var dialogues: Array = []
var current_index: int = 0
var is_typing: bool = false
var full_text: String = ""

func _ready():
	hide()

# Inicia o diálogo
func start_dialogue(dialogue_array: Array) -> void:
	get_tree().current_scene.current_state = \
	get_tree().current_scene.GameState.DIALOGUE
	dialogues = dialogue_array
	current_index = 0
	show()
	show_current_line()

# Mostra a fala atual
func show_current_line() -> void:
	if current_index >= dialogues.size():
		end_dialogue()
		return
	
	full_text = dialogues[current_index]
	type_text(full_text)

# Máquina de escrever
func type_text(text: String) -> void:
	is_typing = true
	text_label.clear()

	for i in range(text.length()):
		if not is_typing:
			text_label.clear()
			text_label.append_text(text)
			return
		
		text_label.append_text(text[i])
		await get_tree().create_timer(0.03).timeout
	
	is_typing = false

# Input para avançar
func _input(event):
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			is_typing = false
		else:
			current_index += 1
			show_current_line()

# Finaliza diálogo
func end_dialogue():
	get_tree().current_scene.current_state = \
	get_tree().current_scene.GameState.EXPLORATION
	
	hide()
	dialogues.clear()
	current_index = 0
	emit_signal("dialogue_finished")
