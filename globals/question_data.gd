extends Node

var question_data: Dictionary = {}

var data_file_path = "res://question_data/MultipleChoiceQuestions - QuestionsSheet.json"

var mc_questions: Array[MCQuestion]

func _ready():
	question_data = load_json_file(data_file_path)
	
	randomize()
	var mc_question_keys = question_data.keys()
	mc_question_keys.shuffle()
	for key in mc_question_keys:
		var new_mc_question = MCQuestion.new()
		new_mc_question.generate_question(question_data[key])
		mc_questions.append(new_mc_question)


func load_json_file(path: String):
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print_debug("ERROR READING FILE")
	else:
		print_debug("QUESTION DATA FILE DOES NOT EXIST")
