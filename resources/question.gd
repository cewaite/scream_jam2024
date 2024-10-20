class_name Question extends Resource

enum DIFFICULTY {EASY, MEDIUM, HARD}

var difficulty: DIFFICULTY

func check_answer(answer):
	assert(false, "no answer to compare to in base Question Resource, so must be overwritten.")
