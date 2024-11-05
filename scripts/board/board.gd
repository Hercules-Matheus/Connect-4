extends Node2D

var board = []
var current_player = 1
var current_player_color: String
var cell_scene = preload("res://scenes/cell/cell.tscn")
var current_hover_column = -1
var is_playing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Soundtrack.play()
	setup_board()

func _process(delta):
	pass

func setup_board():
	print("Ready called")
	#$Control/CenterContainer/GridContainer.size = Vector2(800, 600) 
	print("GridContainer criado")
	for row in range(6):
		var line = []
		for col in range(7):
			line.append(0)
			var cell = cell_scene.instantiate()
			cell.name = "Cell_%d_%d" % [row, col]
			cell.connect("pressed", Callable(self, "_on_cell_pressed").bind(cell))
			cell.row = row
			cell.col = col
			print("Adding cell at row %d, col %d" % [row, col])
			$Control/CenterContainer/GridContainer.add_child(cell)
		board.append(line)
	print("Cells added to GridContainer")

func _on_cell_pressed(cell: TextureButton):
	print("Cell pressed: Row %d, Col %d" % [cell.row, cell.col])
	var row = cell.row
	var col = cell.col
	drop_piece(col)
	$DropSound.play()

func drop_piece(col):
	for row in range(5, -1, -1):
		if board[row][col] == 0:
			board[row][col] = current_player
			update_cell_visual(row, col)
			if current_player == 1:
				current_player_color = "#22abec"
			else:
				current_player_color = "#e11a1a"
			if check_winner(row, col):
				$HUD.show_victory_message(current_player, current_player_color)
				on_game_over()
				$HUD.show_restart_message()
			else:
				current_player = 3 - current_player
			break

func update_cell_visual(row, col):
	var cell = $Control/CenterContainer/GridContainer.get_node("Cell_%d_%d" % [row, col])
	if current_player == 1:
		cell.texture_normal = preload("res://assets/blue_cell.svg")
	else:
		cell.texture_normal = preload("res://assets/red_cell.svg")
	print("Updated cell at row %d, col %d" % [row, col])

func check_winner(row, col):
	return check_direction(row, col, 1, 0) or check_direction(row, col, 0, 1) or check_direction(row, col, 1, 1) or check_direction(row, col, 1, -1)

func check_direction(row, col, delta_row, delta_col):
	var count = 1
	for dir in [-1, 1]:
		var r = row + delta_row * dir
		var c = col + delta_col * dir
		while r >= 0 and r < 6 and c >= 0 and c < 7 and board[r][c] == current_player:
			count += 1
			if count >= 4:
				return true
			r += delta_row * dir
			c += delta_col * dir
	return false

func play_pause_soundtrack():
	print("on play_pause_soundtrack")
	if is_playing:
		print("on if from play_pause_soundtrack")
		$Soundtrack.stream_paused = true
		is_playing = false
	else:
		print("on else from play_pause_soundtrack")
		$Soundtrack.stream_paused = false
		is_playing = true

func on_game_over():
	for child in $Control/CenterContainer/GridContainer.get_children():
		child.disabled = true  # Desabilita o TextureButton
	$WinnerSound.play()
	$Soundtrack.stream_paused = true

func reset_game():
	var _reload: bool = get_tree().reload_current_scene()

func _on_hud_start_game():
	reset_game()

func _on_hud_is_sound_playing():
	play_pause_soundtrack()
