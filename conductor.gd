extends AudioStreamPlayer

@export var bpm = 120;

var beat := 0.0;


func _process(delta: float) -> void:
	beat = get_playback_position() * bpm / 60;
