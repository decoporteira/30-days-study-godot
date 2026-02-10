extends Node
class_name EquipmentHolder

enum SlotType {
	HAND,
	HEAD,
	BODY,
	LEGS,
	ACCESSORY
}

var slots := {}

signal equipment_changed
