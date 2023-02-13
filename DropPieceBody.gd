extends KinematicBody2D

enum{RED = 1, YELLOW = 2}

var piece_row = 0
var piece_col = 0
var piece_color = RED
var isActive = false

signal piece_stopped(color, col_idx, row_idx)

func _on_Main_drop_piece_anim(color, col_idx, row_idx):
	visible = true
	position = get_parent().get_node("MoveOverlay").position
	
	if(color == RED):
		$DropPiece.set_texture(load("res://red_disk.png"))
	elif(color == YELLOW):
		$DropPiece.set_texture(load("res://yellow_disk.png"))
		
	piece_col = col_idx
	piece_row = row_idx
	piece_color = color
	
	isActive = true
	

func _physics_process(_delta):
	
	if isActive:
		var target = Vector2(piece_col * 32 + 16, piece_row * 32 + 16)
		var velocity = position.direction_to(target) * 100 * log(position.distance_to(target))
			
		if position.distance_to(target) > 2:
			velocity = move_and_slide(velocity)
		else:
			position = target
			visible = false
			isActive = false
			emit_signal("piece_stopped", piece_color, piece_col, piece_row)
