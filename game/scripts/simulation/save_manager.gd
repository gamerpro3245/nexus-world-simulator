class_name NexusSaveManager
extends RefCounted

const SAVE_PATH := "user://nexus_save.json"

func save_game(simulation: NexusGameSimulation) -> bool:
	var data := simulation.to_dict()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false

	file.store_string(JSON.stringify(data))
	file.close()
	return true

func load_game(simulation: NexusGameSimulation) -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false

	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	if json.parse(text) != OK:
		return false

	if typeof(json.data) != TYPE_DICTIONARY:
		return false

	simulation.from_dict(json.data)
	return true
