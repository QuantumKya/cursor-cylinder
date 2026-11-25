extends Node2D

@onready var buttonSet = $Control;
@onready var notePlayer = $"La Fanfare";

const PURE_SINE: AudioStream = preload("res://sfx/pure-tone-A440-sine.wav");
const POWERCHORD: AudioStream = preload("res://sfx/3-power-chord-A440-sine.wav");


func _ready() -> void:
	var k := 0;
	for item in TheCircle.SCALES:
		var btn := Button.new();
		var intervals := TheCircle.SCALES[item];
		var change_fn = func(): TheCircle._set_key_from("A", intervals);
		
		btn.pressed.connect(change_fn);
		btn.scale = Vector2(1, 1);
		btn.position = Vector2(50, 50 + k*50);
		btn.text = item;
		
		buttonSet.add_child(btn);
		k += 1;
	
	for i in 2:
		var btn := Button.new();
		var change_fn = func(): _set_sound([PURE_SINE, POWERCHORD][i]);
		btn.pressed.connect(change_fn);
		btn.scale = Vector2(1, 1);
		btn.position = Vector2(1000, 50 + i*100);
		btn.text = ["Pure Sine", "Power Chord"][i];
		
		buttonSet.add_child(btn);

func _process(delta: float) -> void:
	queue_redraw();
	
	var note := TheCircle._get_tone_of_mouse(self);
	var note_pos := TheCircle.CHROMATIC.find(note);
	if note_pos < 0: return;
	
	notePlayer.pitch_scale = pow(2, posmod(note_pos, 12)/12.0);

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"): _play_pitch();
	if event.is_action_released("Click"): _stop_pitch();

func _draw() -> void:
	TheCircle._draw(self);
	TheCircle._draw_mouse_sector(self, Color.hex(0xccbbeeaa));


func _set_sound(sound: AudioStream):
	notePlayer.stream = sound;

func _play_pitch():
	notePlayer.play();
func _stop_pitch():
	notePlayer.stop();
