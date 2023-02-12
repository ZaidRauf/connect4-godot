extends Node2D

enum {BAD_DROP = -1, EMPTY = 0, RED = 1, YELLOW = 2}

var board_state = [
	[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
	[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
	[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
	[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
	[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY],
	[EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY]
	]

const board_rows = 6
const board_columns = 7

signal piece_landed(col_idx, row_idx)
signal drop_piece_anim(color, col_idx, row_idx)
signal winner(color)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func drop_piece(color, col_idx):
	var start_row = 0;
	var drop_row_idx = -1;
	
	while (start_row < board_rows) && (board_state[start_row][col_idx] == EMPTY):
		if(start_row + 1 < board_rows && board_state[start_row+1][col_idx] != EMPTY):
			drop_row_idx = start_row
			start_row += 1
			board_state[drop_row_idx][col_idx] = color
		elif((start_row == board_rows - 1) && (board_state[start_row][col_idx] == EMPTY)):
			drop_row_idx = board_rows - 1
			board_state[drop_row_idx][col_idx] = color
			start_row += 1
		else:
			start_row += 1
	
	return drop_row_idx

func _on_MoveOverlay_dropped_piece(color, idx):
	var drop_idx = drop_piece(color, idx)
	
	if(drop_idx != BAD_DROP):
		# Due to not a tight board map
		drop_idx += 2
		if(color == RED):			
			emit_signal("drop_piece_anim", color, idx, drop_idx) 
		elif(color == YELLOW):
			emit_signal("drop_piece_anim", color, idx, drop_idx) 

func check_for_win(color, col_idx, row_idx):
	var win_str = String(color) + String(color) + String(color) + String(color)
	# Check Row of Drop
	
	var row_str = ""
	for i in board_state[row_idx]:
		row_str += String(i)
	
	# Check Column of Drop
	var col_str = ""
	for i in range(board_rows):
		col_str += String(board_state[i][col_idx])

	# Check Diagonals of Drop
	
	# Diagonal 1
	var diagonal_1_start_row_idx = row_idx - min(col_idx, row_idx)
	var diagonal_1_start_col_idx = col_idx - min(col_idx, row_idx)
	
	var diag_1_str = ""
	var x = diagonal_1_start_row_idx
	var y = diagonal_1_start_col_idx
	while((x < board_rows) && (y < board_columns)):
		diag_1_str += String(board_state[x][y])
		x += 1
		y += 1
	
	# Diagonal 2
	var diagonal_2_start_row_idx = row_idx + min((5 - row_idx), col_idx)
	var diagonal_2_start_col_idx = col_idx - min((5 - row_idx), col_idx)
	
	var diag_2_str = ""
	x = diagonal_2_start_row_idx
	y = diagonal_2_start_col_idx
	while((x > -1) && (y < board_columns)):
		diag_2_str += String(board_state[x][y])
		x -= 1
		y += 1
	
	return (win_str in col_str) || (win_str in row_str) || (win_str in diag_1_str) || (win_str in diag_2_str)

func _on_DropPieceBody_piece_stopped(color, col_idx, row_idx):
	if(color == RED):			
		$GameBoard.set_cell(col_idx, row_idx, 2)
		emit_signal("piece_landed", col_idx, row_idx)
	elif(color == YELLOW):
		$GameBoard.set_cell(col_idx, row_idx, 4)
		emit_signal("piece_landed", col_idx, row_idx)

	# Translate back to board space
	var win_result = check_for_win(color, col_idx, row_idx-2)
	if(win_result):
		emit_signal("winner", color)
