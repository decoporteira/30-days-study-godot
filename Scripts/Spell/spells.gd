extends Resource
class_name Spell

@export var id: String
@export var name: String
@export var element: Element
@export var mp_cost: int = 0
@export var power: int = 0
@export var description: String
@export var icon: Texture2D
@export var spell_context: SpellContext

enum Element {
	FIRE,
	WATER,
	EARTH,
	WIND,
	HEAL
}

enum SpellContext {
	BATTLE,
	MENU
}

func can_be_used(context: SpellContext) -> bool:
	match context:
		SpellContext.BATTLE:
			return true
		SpellContext.MENU:
			return element == Element.HEAL
	
	return false
