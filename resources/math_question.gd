class_name MathQuestion extends Question

var num1: int
var num2: int
var operator: String
var answer: int

func generate_question():
	randomize()
	var operators = ["+", "-", "*"]
	operator = operators.pick_random()
	match self.difficulty:
		DIFFICULTY.EASY:
			num1 = randi_range(1, 9)
			num2 = randi_range(1, 9)
		DIFFICULTY.MEDIUM:
			num1 = randi_range(10, 99)
			num2 = randi_range(10, 99)
		DIFFICULTY.HARD:
			num1 = randi_range(100, 999)
			num2 = randi_range(100, 999)
	calc_answer()

func calc_answer():
	match operator:
		"+":
			answer = num1 + num2
		"-":
			answer = num1 - num2
		"*":
			answer = num1 * num2

func check_answer(answer):
	return self.answer == int(answer)

func question_to_string() -> String:
	return str(num1) + " " + operator + " " + str(num2)
