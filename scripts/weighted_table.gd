class_name WeightedTable


var item_arr: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
	item_arr.append({
		"item": item,
		"weight": weight
	})
	weight_sum += weight


func pick_item():
	var threshold = randi_range(1, weight_sum)
	var current_weight_sum = 0
	for item in item_arr:
		current_weight_sum += item["weight"]
		if current_weight_sum >= threshold:
			return item["item"]
