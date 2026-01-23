class_name WeaponItemResource
extends ItemResource

@export var attack_power: int
@export var element: String
@export var weapon_type: String
@export var critical_chance: int

enum WeaponType {
	SWORD,
	LANCE,
	HAMMER
}
