class_name Subject extends Node

func answer_question(question: Question, strikes: int):
	var accuracy = 1.0 - (0.2 * strikes)
	
	if question is MathQuestion:
		var error = randi_range(1, (1 + (5 * strikes)))
		
		if accuracy >= randi_range(0, 1):
			return str(question.answer)
		else:
			return str(randi_range(question.answer - error, question.answer + error))
	if question is MCQuestion:
		if accuracy >= randi_range(0, 1):
			return question.answer
		else:
			var options = ["A", "B", "C", "D"]
			return options.pick_random()
