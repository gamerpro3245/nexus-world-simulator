class_name SaveManager
extends RefCounted
const SAVE_PATH := "user://nexus_save.json"
static func save_world(world: WorldState) -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null: return false
	file.store_string(JSON.stringify({"version":1,"year":world.year,"month":world.month,"treasury":world.treasury,"population":world.population,"welfare":world.welfare,"trust":world.trust,"corruption":world.corruption,"unemployment":world.unemployment,"industrial_capacity":world.industrial_capacity,"research_points":world.research_points}))
	file.close()
	return true
static func load_world(world: WorldState) -> bool:
	if not FileAccess.file_exists(SAVE_PATH): return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null: return false
	var data=JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) != TYPE_DICTIONARY: return false
	world.year=int(data.get("year",world.year)); world.month=int(data.get("month",world.month)); world.treasury=float(data.get("treasury",world.treasury)); world.population=int(data.get("population",world.population)); world.welfare=float(data.get("welfare",world.welfare)); world.trust=float(data.get("trust",world.trust)); world.corruption=float(data.get("corruption",world.corruption)); world.unemployment=float(data.get("unemployment",world.unemployment)); world.industrial_capacity=float(data.get("industrial_capacity",world.industrial_capacity)); world.research_points=float(data.get("research_points",world.research_points))
	return true
