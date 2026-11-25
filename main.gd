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
	if notes.is_empty(): return;
	var note = notes[0];
	var time = note[0];
	var tone = note[1];
	
	var sector := TheCircle._find_mouse_sector(self);
	var target := TheCircle._get_sector_from_tone(tone);
	if sector == target and abs(conductor.beat - time) < 0.5:
		notes.pop_front();
		score += 1;



func _draw() -> void:
	TheCircle._draw(self);
	
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
	
	TheCircle._draw_mouse_sector(self, Color.hex(0xccbbeeaa));
