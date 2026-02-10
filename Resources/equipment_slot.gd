class_name EquipmentSlot

var equipped_item: ItemResource = null

func is_empty() -> bool:
	return equipped_item == null

func equip(item: ItemResource):
	equipped_item = item

func unequip():
	var old = equipped_item
	equipped_item = null
	return old
