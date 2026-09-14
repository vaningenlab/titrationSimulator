% dispQuestion.m

function formattedQuestion=dispQuestion(number)

	ESC  = char(27);   
 	RED  = [ESC '[1;31m'];
 	WHT  = [ESC '[1;37m' ESC '[0m'];

 	formattedQuestion = sprintf("%s%s%d%s%s", RED, "question(", number, ")", WHT);

endfunction