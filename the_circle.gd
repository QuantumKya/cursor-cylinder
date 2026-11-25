extends Node

const CHROMATIC = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"];

# interval sets
const SCALES: Dictionary[String, Array] = {
	"MAJOR": [2, 2, 1, 2, 2, 2],
	"MINOR": [2, 1, 2, 2, 1, 2],
	"BLUES": [3, 2, 1, 1, 3],
	
	"PENTATONIC": [2, 2, 3, 2],
	"INSEN": [1, 4, 2, 3],
	"HUNGARIAN": [2, 1, 3, 1, 1, 3],
	"PHRYGIAN": [1, 2, 2, 2, 1, 2],
	
	"CHROM": [1,1,1,1,1,1,1,1,1,1],
};



var tone_map = CHROMATIC;
var num_tones := 12;
var key_tone := "A"; # haha that sounds like "ketone"

func _set_key_notes(notes: Array[String]):
	tone_map = notes;
	key_tone = notes[0];
	num_tones = len(notes);

func _set_key_from(base: String, intervals):
	var tone := CHROMATIC.find(base);
	if (tone < 0): return;
	
	key_tone = base;
	num_tones = len(intervals) + 1;
	tone_map = [base];
	
	var l := tone;
	for i in intervals:
		l = posmod(l + i, 12); # must stay within chromatic scale
		tone_map.append(CHROMATIC[l]);

func _set_key_major(base: String):
	_set_key_from(base, SCALES.MAJOR);

func _set_key_minor(base: String):
	_set_key_from(base, SCALES.MINOR);




const center := Vector2(640, 360);
const outerR = 300;
const innerR = 175;


func _find_sector_of(pos: Vector2) -> int: # always returns positive values
	var rel_pos = pos - center;
	var angle = floori((rel_pos.angle() + PI/2) / TAU * num_tones + 0.5);
	var r = rel_pos.length();
	
	if (r >= innerR and r <= outerR): return posmod(angle, num_tones);
	else: return -1;

func _find_mouse_sector(node: CanvasItem) -> int:
	var mouse_pos := node.get_local_mouse_position();
	return TheCircle._find_sector_of(mouse_pos);


func _get_angles_from_sector(sector: int) -> Array[float]:
	var angle1 = TAU * (sector-0.5)/float(num_tones) - PI/2;
	var angle2 = TAU * (sector+0.5)/float(num_tones) - PI/2;
	return [angle1, angle2];


func _get_sector_from_tone(tone: String) -> int:
	var tone_pos := tone_map.find(tone);
	var key_pos := tone_map.find(key_tone);
	
	return posmod(tone_pos - key_pos, num_tones);

func _get_tone(sector: int) -> String:
	return tone_map[sector];

func _get_tone_of_mouse(node: CanvasItem) -> String:
	var part := TheCircle._find_mouse_sector(node);
	if part < 0: return "";
	
	return TheCircle._get_tone(part);


func _get_point_in(angle: float, dist: float) -> Vector2:
	return center + dist * Vector2.RIGHT.rotated(angle);
func _get_point_on(angle: float) -> Vector2:
	return _get_point_in(angle, outerR);


func _generate_sector_default(angle1: float, angle2: float) -> PackedVector2Array:
	return Utility._generate_annulus_slice(center, innerR, outerR, angle1, angle2);



func _draw(node: CanvasItem) -> void:
	# draw circle
	node.draw_circle(TheCircle.center, TheCircle.outerR, Color.WHITE, false, 5);
	
	# draw segments
	var n: int = TheCircle.num_tones;
	for i in n:
		# draw text for note names
		var angle = TAU * i/float(n) - PI/2;
		var label_pos = TheCircle._get_point_in(angle, TheCircle.outerR + 25);
		node.draw_string(ThemeDB.fallback_font, label_pos,
			TheCircle._get_tone(i), HORIZONTAL_ALIGNMENT_CENTER
		);
		
		# draw dividing lines
		var offangle = TAU * (i+0.5)/float(n) - PI/2;
		var start = TheCircle._get_point_in(offangle, TheCircle.innerR);
		var end = TheCircle._get_point_in(offangle, TheCircle.outerR);
		node.draw_line(start, end, Color.WHITE);

func _draw_mouse_sector(node: CanvasItem, color: Color):
	# draw region mouse is in (for testing)
	var mouseRegion = _find_mouse_sector(node);
	var angles = _get_angles_from_sector(mouseRegion);
	
	if mouseRegion >= 0:
		var points := TheCircle._generate_sector_default(angles[0], angles[1]);
		node.draw_colored_polygon(points, color);
