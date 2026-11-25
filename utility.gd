extends Node

func _generate_annulus_slice(center: Vector2,
	r1: float, r2: float, a1: float, a2: float,
	segments: int = 12) -> PackedVector2Array:
	
	var points := PackedVector2Array([]);
	var radii = [r1, r2];
	for r in 2: for i in (segments+1): # first pass is positive direction, second negative
		var factor = i/float(segments) if r%2 == 0 else (1 - i/float(segments));
		var mid_angle = lerp(a1, a2, factor);
		
		points.append(
			center + Vector2.RIGHT.rotated(mid_angle) * radii[r]
		);
	
	return points;
