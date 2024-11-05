extends TextureButton

var row: int
var col: int

func _ready():
	texture_normal = preload("res://assets/default_cell.svg")

# Função para definir o hover visualmente
func apply_hover():
	texture_normal = preload("res://assets/hover_cell.svg")

# Função para remover o hover
func remove_hover():
	texture_normal = preload("res://assets/default_cell.svg")


