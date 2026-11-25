extends Node2D

@onready var conductor = $"La Fanfare";

var notes = [
	[1, "D"],
	[2.5, "D"],
	[3.5, "A"],
	[4.5, "D"],
	[7.5, "E"],
	[8.5, "D"],
	[10, "D"],
	[11, "A"],
	[12, "D"],
	[15, "F"],
];

var score := 0;

func _process(delta: float) -> void:
	queue_redraw();
	
	for note in notes:
		var time = note[0];
		if time < conductor.beat - 0.5: notes.pop_front();



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		_handle_click();
		

func _handle_click() -> void:
	var note = notes[0];
	var time = note[0];
	var tone = note[1];
	
	var sector := _find_mouse_sector();
	var target := TheCircle._get_sector_from_tone(tone);
	if sector == target and abs(conductor.beat - time) < 0.5:
		notes.pop_front();
		score += 1;


func _find_mouse_sector() -> int:
	var mouse_pos := get_local_mouse_position();
	return TheCircle._find_sector_of(mouse_pos);



func _draw() -> void:
	# draw circle
	draw_circle(TheCircle.center, TheCircle.outerR, Color.WHITE, false, 5);
	
	# draw segments
	var n := TheCircle.num_tones;
	for i in n:
		# draw text for note names
		var angle = TAU * i/float(n) - PI/2;
		var label_pos = TheCircle._get_point_in(angle, TheCircle.outerR + 25);
		draw_string(ThemeDB.fallback_font, label_pos,
			TheCircle._get_tone(i), HORIZONTAL_ALIGNMENT_CENTER
		);
		
		# draw dividing lines
		var offangle = TAU * (i+0.5)/float(n) - PI/2;
		var start = TheCircle._get_point_in(offangle, TheCircle.innerR);
		var end = TheCircle._get_point_in(offangle, TheCircle.outerR);
		draw_line(start, end, Color.WHITE);
	
	draw_string(ThemeDB.fallback_font, Vector2(60, 60), "Score: " + str(score));
	
	for note in notes:
		var time = note[0];
		var tone = note[1];
		
		var timeDiff = (conductor.beat - time);
		if timeDiff < -8: continue;
		
		var segment = TheCircle._get_sector_from_tone(tone);
		var angles = TheCircle._get_angles_from_sector(segment);
		var r = TheCircle.outerR * (1 + timeDiff/8);
		
		draw_arc(TheCircle.center, r, angles[0], angles[1], 12, Color.WHITE, 10);
	
	
	# draw region mouse is in (for testing)
	var mouseRegion = _find_mouse_sector();
	var angles = TheCircle._get_angles_from_sector(mouseRegion);
	
	if mouseRegion >= 0:
		var points := TheCircle._generate_sector_default(angles[0], angles[1]);
		draw_colored_polygon(points, Color.hex(0xccbbeeaa));
