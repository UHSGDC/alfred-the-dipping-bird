extends Node

const fade_time: float = 1

enum Track {
	TITLE,
	MIDWEST,
	CHICAGO,
	NIAGARA,
	JAPAN
}

var current_player: AudioStreamPlayer

@onready var stream_players: Array[AudioStreamPlayer] = [$Title, $Midwest, $Chicago, $Niagara, $Icy, $Japan]


func _ready() -> void:
	stream_players[Track.TITLE].play()
	stream_players[Track.TITLE].stream_paused = true


func fade_to_track(track: Track) -> void:
	if (stream_players[track] == current_player):
		return
	var tween: Tween = create_tween()
	var prev_player: AudioStreamPlayer = current_player
	tween.tween_property(prev_player, "volume_db", -40, fade_time)
	
	current_player = stream_players[track]
	current_player.volume_db = -40
	if track == Track.TITLE:
		current_player.stream_paused = false
	else:
		current_player.play()
		
	tween.parallel().tween_property(current_player, "volume_db", 0, fade_time)
	await tween.finished
	prev_player.stream_paused = true


func play_track(track: Track) -> void:
	if (stream_players[track] == current_player):
		return
	if current_player:
		current_player.stream_paused = true
	current_player = stream_players[track]
	current_player.volume_db = 0
	if track == Track.TITLE:
		current_player.stream_paused = false
	else:
		current_player.play()
