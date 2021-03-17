extends Panel

var is_expanded = false

var ItemListContent = [
	"Recolher 5 Apontamentos",
	"Recolher 5 Finos",
	"Conversar com 5 Estudantes",
	"Entregar 3 Projetos",
	"Passar a um Teste", #encontrar a sala e responder a metade das perguntas corretamente
	]
var SecretItemList = [
	"Convencer um Prof a Subir-te a Nota", #através de um diálogo elaborado
	"Encontrar os Apontamentos Mágicos", #estão encondidos algures na FEUP e permitem completar challenges académicos automaticamente
	"Encontrar o Fantasma da FEUP", #só engraçado -> o fantasma conta-te histórias engraçadas da FEUP
	"Matar um Zombie", #pressionando uma tecla random tipo F perto de um zombie 
	"Copiar num Teste", #encontrar uma sala de testes e convencer um estudante a deixar-te copiar
]

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

	complete_challenge(1)
	challenge_in_progress(2)
	add_secret_challenge("Secret Challenge 1")
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
		rect_size.y = lerp(rect_size.y, 120, 0.1)
		rect_size.x = lerp(rect_size.x, 300, 0.1)
		button.text = "-"
		if rect_size.x >= 299:
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
	print(ItemNo)
	
func complete_challenge(item_id):
	item_list.set_item_custom_bg_color(item_id, Color(0, 0.3, 0, 1))
	
func challenge_in_progress(item_id):
	item_list.set_item_custom_bg_color(item_id, Color(0.8, 0.8, 0, 1))
	
func add_secret_challenge(text):
	item_list.add_item(text,null,false)
	complete_challenge(item_list.get_item_count() - 1)
