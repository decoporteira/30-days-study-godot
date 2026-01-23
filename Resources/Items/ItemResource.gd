class_name ItemResource
extends Resource

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var description: String
@export var price: int

enum ItemType {
	WEAPON,
	ARMOR,
	CONSUMABLE
}
