class_name Subject extends Node

func answer_question(question: Question, strikes: int):
	var accuracy = 1.0 - (0.2 * strikes)
	var error = randi_range(0, 10 * strikes)
	
	if question is MathQuestion:
		if accuracy >= randi_range(0, 1):
			return str(question.answer)
		else:
			return str(randi_range(question.answer - error, question.answer + error))
