class_name NexusProvince
extends RefCounted

var id: int
var province_name: String
var population: int
var infrastructure: float = 50.0
var jobs: int
var production: float = 0.0
var development: float = 50.0

func _init(province_id: int, name: String, province_population: int) -> void:
	id = province_id
	province_name = name
	population = province_population
	jobs = int(province_population * 0.45)
