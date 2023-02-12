extends Sprite

enum {BAD_DROP = -1, EMPTY = 0, RED = 1, YELLOW = 2}

var curr_state = RED
var red_disk_texture = preload("res://red_disk.png")
var yellow_disk_texture = preload("res://yellow_disk.png")
var isActive = true

signal dropped_piece(color, idx)

func _process(_delta):
	if isActive:
		var mp = get_viewport().get_mouse_position()
		mp.y = 48
		mp.x = clamp(floor((mp.x - 32)/64)*32 + 16, 16, 208)
		position = mp
		
		if Input.is_action_just_pressed("click") && !get_parent().get_node("DropPieceBody").isActive:
			var disk_col = (mp.x - 16)/32
			emit_signal("dropped_piece", curr_state, disk_col)

func change_disk_texture():
	if(curr_state == RED):
		set_texture(yellow_disk_texture)
		curr_state = YELLOW
	elif (curr_state == YELLOW):
		set_texture(red_disk_texture)
		curr_state = RED

func _on_Main_piece_landed(_drop_idx, _col_idx):
	change_disk_texture()


func _on_Main_winner(_color):
	isActive = false
