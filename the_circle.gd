extends Node

const tone_map = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"];
const num_tones := 12;
var key_tone := "A"; # haha that sounds like "ketone"

const center := Vector2(640, 360);
const outerR = 300;
const innerR = 175;


func _find_sector_of(pos: Vector2) -> int: # always returns positive values
	var rel_pos = pos - center;
	var angle = floori(rel_pos.angle() / TAU * 12 + 3 + 0.5);
	var r = rel_pos.length();
	
	if (r >= innerR and r <= outerR): return posmod(angle, 12);
	else: return -1;

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

func _get_point_in(angle: float, dist: float) -> Vector2:
	return center + dist * Vector2.RIGHT.rotated(angle);
func _get_point_on(angle: float) -> Vector2:
	return _get_point_in(angle, outerR);


func _generate_sector_default(angle1: float, angle2: float) -> PackedVector2Array:
	return Utility._generate_annulus_slice(center, innerR, outerR, angle1, angle2);
