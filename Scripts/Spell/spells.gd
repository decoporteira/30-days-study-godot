extends Resource
class_name Spell

@export var id: String
@export var name: String
@export var element: Element
@export var mp_cost: int = 0
@export var power: int = 0
@export var description: String
@export var icon: Texture2D

enum Element {
	FIRE,
	WATER,
	EARTH,
	WIND,
	HEAL
}
