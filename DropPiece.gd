extends Sprite

var red_disk_texture = preload("res://red_disk.png")
var yellow_disk_texture = preload("res://yellow_disk.png")

var piece_row = 0
var piece_col = 0

func _on_Main_drop_piece_anim(color, piece_col, piece_row):
	visible = true
	position = get_parent().get_node("MoveOverlay").position
	set_texture(color)

func _physics_process(delta):
	pass
