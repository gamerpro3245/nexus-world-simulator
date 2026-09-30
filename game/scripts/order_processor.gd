class_name OrderProcessor
extends RefCounted
func execute(world: WorldState, order: NexusOrder) -> String:
	var text := order.text.to_lower()
	if "завод" in text or "производ" in text:
		world.industrial_capacity += 0.5; world.treasury -= 40.0; order.type="industry"
		return "Промышленный проект: +0.5 мощности, −40 бюджета."
	if "налог" in text:
		world.treasury += 30.0; world.welfare=clamp(world.welfare-0.5,0.0,100.0); order.type="tax"
		return "Налоговая мера: +30 бюджета, −0.5 благосостояния."
	if "исслед" in text or "наук" in text:
		world.research_points += 8.0; world.treasury -= 20.0; order.type="research"
		return "Исследовательская программа: +8 науки, −20 бюджета."
	world.treasury -= 10.0
	return "Общий приказ: −10 бюджета. AI-интерпретация будет подключена позже."
