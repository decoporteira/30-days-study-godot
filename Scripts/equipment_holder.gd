extends Node
class_name EquipmentHolder
#equipament_holder
enum SlotType {
	HAND,
	HEAD,
	BODY,
	LEGS,
	ACCESSORY
}

var slots := {}

signal equipment_changed

func _ready():
	for slot_type in SlotType.values():
		slots[slot_type] = EquipmentSlot.new()

func equip(item: ItemResource) -> bool:
	match item.item_type:
		ItemResource.ItemType.WEAPON:
			return _equip_weapon(item)
		ItemResource.ItemType.ARMOR:
			return _equip_armor(item)
		_:
			return false
			
func _equip_weapon(item: WeaponItemResource) -> bool:
	slots[SlotType.HAND].equip(item)
	equipment_changed.emit()
	return true
	
func _equip_armor(item: ArmorItemResource) -> bool:
	var slot_map = {
		ArmorItemResource.ArmorSlot.HEAD: SlotType.HEAD,
		ArmorItemResource.ArmorSlot.BODY: SlotType.BODY,
		ArmorItemResource.ArmorSlot.LEGS: SlotType.LEGS,
		ArmorItemResource.ArmorSlot.ACCESSORY: SlotType.ACCESSORY
	}

	var target_slot = slot_map[item.slot]
	slots[target_slot].equip(item)
	equipment_changed.emit()
	return true
