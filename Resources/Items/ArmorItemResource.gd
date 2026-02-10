extends ItemResource
class_name ArmorItemResource

@export var defense: int
@export var slot: ArmorSlot # head, body, etc

enum ArmorSlot {
	HEAD,
	BODY,
	LEGS,
	ACCESSORY
}
