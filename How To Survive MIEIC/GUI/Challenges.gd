extends Panel

var is_expanded = false
var mainScene
################################
#TO CHECK (linhas 49, 50 e 123)
#Quando todos os challenges estiverem completos, chamar a função game_win() na mainscene.gd
#################################

#each challenge defined has [challenge_id, challenge_description, challenge_completed, challenge_countable, challenge_current, challenge_max]
# challenge completed: 0-> not completed, 1-> under completion, 2->completed
var ChallengeID = 0
var ChallengeDescription = 1
var ChallengeCompleted = 2
var ChallengeCountable = 3
var ChallengeCurrent = 4
var ChallengeMax = 5
var challenges = [
	[0, "Recolher 5 Apontamentos", 0, true, 0, 5],
	[1, "Recolher 5 Finos", 0, true, 0, 5],
	[2, "Conversar com 5 Estudantes", 0, true, 0, 5],
	[3, "Entregar 3 Projetos", 0, true, 0, 3],
	[4, "Passar a um Teste", 0, false]
]

var SecretItemList = [
	"Discover how to pass the exam with 0 effort", #dar 5 cervejas a estudantes
	"Convencer um Prof a Subir-te a Nota", #através de um diálogo elaborado
	"Encontrar os Apontamentos Mágicos", #estão encondidos algures na FEUP e permitem completar challenges académicos automaticamente
	"Encontrar o Fantasma da FEUP", #só engraçado -> o fantasma conta-te histórias engraçadas da FEUP
	"Matar um Zombie", #pressionando uma tecla random tipo F perto de um zombie 
	"Copiar num Teste", #encontrar uma sala de testes e convencer um estudante a deixar-te copiar
]

var item_list
var button
var count = 0
func _ready():
	$VBoxContainer/show.connect("pressed",self,"expand")
	#Load the ItemList by stepping through it and adding each item.
	item_list =  get_node("ItemList")
	button =  get_node("VBoxContainer/show")
	
	for challenge_id in range(challenges.size()):
		item_list.add_item(challenge_to_string(challenge_id), null, false)
		item_list.set_item_custom_bg_color(challenge_id, Color(0.6, 0, 0, 1))
		item_list.set_item_custom_fg_color(challenge_id, Color(1, 1, 1, 1))

func expand():
	is_expanded = !is_expanded

var last_rect_size = Vector2.ZERO
func _process(_delta):

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
	return item_list.get_selected_items()
	
func complete_challenge(challenge_id):
	challenges[challenge_id][ChallengeCompleted] = 2
	item_list.set_item_custom_bg_color(challenge_id, Color(0, 0.3, 0, 1))
	
func is_challenge_completed(challenge_id):
	return challenges[challenge_id][ChallengeCompleted] == 2

func all_main_challenges_completed():
	for i in range(challenges.size()):
		if !is_challenge_completed(challenges[i][ChallengeID]):
			return false
	return true
	
func challenge_in_progress(challenge_id):
	item_list.set_item_custom_bg_color(challenge_id, Color(0.5, 0.5, 0, 1))
	challenges[challenge_id][ChallengeCompleted] = 1;
	
func add_secret_challenge(text):
	var challenge_id = add_challenge(text)
	complete_challenge(challenge_id)

func add_countable_challenge(item_content, item_current, item_max):
	var challenge_id = challenges.size;
	challenges.push_back([challenge_id, item_content, 0, true, item_current, item_max])
	item_list.add_item(challenge_to_string(challenge_id), null, false)
	item_list.set_item_custom_bg_color(challenge_id, Color(0.6, 0, 0, 1))
	item_list.set_item_custom_fg_color(challenge_id, Color(1, 1, 1, 1))
	return challenge_id

func add_challenge(item_content):
	var challenge_id = challenges.size();
	challenges.push_back([challenge_id, item_content, 0, false])
	item_list.add_item(challenge_to_string(challenge_id), null, false)
	item_list.set_item_custom_bg_color(challenge_id, Color(0.6, 0, 0, 1))
	item_list.set_item_custom_fg_color(challenge_id, Color(1, 1, 1, 1))
	return challenge_id

func update_challenge(challenge_id, new_current):
	challenges[challenge_id][ChallengeCurrent] = new_current
	if new_current >= challenges[challenge_id][ChallengeMax]:
		complete_challenge(challenge_id)
		count+=1
		if all_main_challenges_completed():
			GlobalVariables.game_win()
	elif (challenges[challenge_id][ChallengeCompleted] == 0 && new_current > 0):
		challenge_in_progress(challenge_id)
		
	item_list.set_item_text(challenge_id, challenge_to_string(challenge_id))

func challenge_to_string(challenge_id):
	var item = challenges[challenge_id]
	var string_item = item[ChallengeDescription]
	if item[ChallengeCountable] && item[ChallengeCompleted] == 1:
		for i in range(85 - item[ChallengeDescription].length()*2.75):
			string_item += " "
		string_item += str(item[ChallengeCurrent]) + "/" + str(item[ChallengeMax])
	return string_item
