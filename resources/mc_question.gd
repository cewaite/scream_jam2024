class_name MCQuestion extends Question

var question: String
var a: String
var b: String
var c: String
var d: String
var answer: String

func check_answer(answer):
	return self.answer == answer

func generate_question(data: Dictionary):
	question = data["question"]
	a = data["a"]
	b = data["b"]
	c = data["c"]
	d = data["d"]
	answer = data["answer"]

func get_choice_from_letter(letter: String) -> String:
	match letter:
		"A":
			return a
		"B":
			return b
		"C":
			return c
		"D":
			return d
	print_debug("Letter not picking a choice")
	return ""
