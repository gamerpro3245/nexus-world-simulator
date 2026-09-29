class_name NexusOrderFactory
extends RefCounted

func build_factory(province_id: int) -> NexusBuildOrder:
	return NexusBuildOrder.new(province_id, "Завод", 6, 120_000.0, 2_000, 12.0)

func build_electronics_factory(province_id: int) -> NexusBuildOrder:
	return NexusBuildOrder.new(province_id, "Электронный завод", 8, 180_000.0, 3_000, 20.0)

func build_power_plant(province_id: int) -> NexusBuildOrder:
	return NexusBuildOrder.new(province_id, "Электростанция", 10, 220_000.0, 1_500, 15.0)
