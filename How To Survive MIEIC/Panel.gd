extends Panel

var is_expanded = false

#each challenge defined has [challenge_id, challenge_description, challenge_completed, challenge_countable, challenge_current, challenge_max]
# challenge completed: 0-> not completed, 1-> under completion, 2->completed
var challenge_id = 0
var challenge_description = 1
var challenge_completed = 2
var challenge_countable = 3
var challenge_current = 4
var challenge_max = 5
var challenges = [
	[0, "Recolher 5 Apontamentos", 0, true, 0, 5],
	[1, "Recolher 5 Finos", 0, true, 0, 5],
	[2, "Conversar com 5 Estudantes", 0, true, 0, 5],
	[3, "Entregar 3 Projetos", 0, true, 0, 3],
	[4, "Passar a um Teste", 0, false]
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
	
	for challenge_id in range(challenges.size()):
		item_list.add_item(challenge_to_string(challenge_id), null, false)
		item_list.set_item_custom_bg_color(challenge_id, Color(0.6, 0, 0, 1))
		item_list.set_item_custom_fg_color(challenge_id, Color(1, 1, 1, 1))

	update_challenge(1, 5)
	update_challenge(2, 3)
	add_secret_challenge("Secret Challenge 1")

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
	
func complete_challenge(challenge_id):
	challenges[challenge_id][challenge_completed] = 2;
	item_list.set_item_custom_bg_color(challenge_id, Color(0, 0.3, 0, 1))
	
func challenge_in_progress(challenge_id):
	item_list.set_item_custom_bg_color(challenge_id, Color(0.5, 0.5, 0, 1))
	challenges[challenge_id][challenge_completed] = 1;
	
func add_secret_challenge(text):
	var challenge_id = add_challenge(text)
	complete_challenge(challenge_id)

func add_countable_challenge(item_content, item_current, item_max):
	var challenge_id = challenges.size;
	challenges.push_back([challenge_id, item_content, 0, true, item_current, item_max])
	item_list.add_item(challenge_to_string(challenge_id), null, false)
	item_list.set_item_custom_bg_color(challenge_id, Color(0.6, 0, 0, 1))
	item_list.set_item_custom_fg_color(challenge_id, Color(1, 1, 1, 1))

func add_challenge(item_content):
	var challenge_id = challenges.size();
	challenges.push_back([challenge_id, item_content, 0, false])
	item_list.add_item(challenge_to_string(challenge_id), null, false)
	item_list.set_item_custom_bg_color(challenge_id, Color(0.6, 0, 0, 1))
	item_list.set_item_custom_fg_color(challenge_id, Color(1, 1, 1, 1))
	return challenge_id

func update_challenge(challenge_id, new_current):
	challenges[challenge_id][challenge_current] = new_current
	if new_current >= challenges[challenge_id][challenge_max]:
		complete_challenge(challenge_id)
	elif (challenges[challenge_id][challenge_completed] == 0 && new_current > 0):
		challenge_in_progress(challenge_id)
		
	item_list.set_item_text(challenge_id, challenge_to_string(challenge_id))

func challenge_to_string(challenge_id):
	var item = challenges[challenge_id]
	var string_item = item[challenge_description]
	if item[challenge_countable] && item[challenge_completed] == 1:
		for i in range(95 - item[challenge_description].length()*2.75):
			string_item += " "
		string_item += str(item[challenge_current]) + "/" + str(item[challenge_max])
	return string_item
