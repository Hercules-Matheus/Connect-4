extends CanvasLayer

signal start_game
signal is_sound_playing
var is_playing = true
@onready var play_texture = preload("res://assets/play_soundtrack.png")
@onready var pause_texture = preload("res://assets/block_soundtrack.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_victory_message(winner, winner_color):
	$LabelWinner.text = "Jogador  %d  ganhou!" % winner
	# Definir a cor do texto
	$LabelWinner.modulate = Color(winner_color)
	$TextureButton.disabled = true

func show_restart_message():
	$ReplayButton.text = "Jogar Novamente"
	$ReplayButton.show()

func _on_replay_button_pressed():
	show_restart_message()
	start_game.emit()

func change_soundtrack_texture():
	print("on change_soundtrack")
	if is_playing:
		print("on if from change_soundtrack")
		$TextureButton.texture_normal = pause_texture
		is_playing = false
	else:
		print("on else from change_soundtrack")
		$TextureButton.texture_normal = play_texture
		is_playing = true

func _on_texture_button_pressed():
	change_soundtrack_texture()
	is_sound_playing.emit()
