extends Panel

var is_expanded = false

var ItemListContent = ["We shall go this way","We shall go that way","which way shall we go?","I think we're lost", "We shall go this way","We shall go that way"]
var item_list
var button

func _ready():
	$VBoxContainer/show.connect("pressed",self,"expand")
	#Load the ItemList by stepping through it and adding each item.
	item_list =  get_node("ItemList")
	button =  get_node("VBoxContainer/show")
	
	for ItemID in range(ItemListContent.size()):
		item_list.add_item(ItemListContent[ItemID],null,false)
		item_list.set_item_custom_bg_color(ItemID, Color(0.6, 0, 0, 1))

	complete_challenge(2)
	#item_list.select(0,true) #This sets a default so we don't have

func expand():
	is_expanded = !is_expanded

var last_rect_size = Vector2.ZERO
func _process(delta):

	#snap to end
	if abs(rect_size.y-rect_min_size.y) < 1:
		rect_size.y = rect_min_size.y
	if abs(rect_size.x-rect_min_size.x) < 1:
		rect_size.x = rect_min_size.x

	#resize to target size
	if is_expanded:
		rect_size.y = lerp(rect_size.y, 140, 0.1)
		rect_size.x = lerp(rect_size.x, 200, 0.1)
		button.text = "-"
		if rect_size.x >= 199:
			item_list.visible = true

	else:
		rect_size.y = lerp(rect_size.y, rect_min_size.y, 0.1)
		rect_size.x = lerp(rect_size.x, rect_min_size.x, 0.1)
		item_list.visible = false
		button.text = "+"

	#update layout
	if last_rect_size != rect_size:
		get_parent().update()
		last_rect_size = rect_size

func ReportListItem():
	var ItemNo = item_list.get_selected_items()

	#The output ItemNo is a list of selected items.  Use this to select
	#The matching component from the associated array, ItemListContent.

	var SelectedItemtext = ItemListContent[ItemNo[0]]
	get_node("Label - output").set_text(str(SelectedItemtext))
	print(ItemNo)
	
func complete_challenge(item_id):
	item_list.set_item_custom_bg_color(item_id, Color(0, 0.3, 0, 1))
