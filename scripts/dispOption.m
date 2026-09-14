% dispOption.m

function formattedOption=dispOption(option, optionString)

	ESC  = char(27);   
 	RED  = [ESC '[1;31m'];
 	WHT  = [ESC '[1;37m' ESC '[0m'];

 	formattedOption = sprintf("\t%s%s%s%s%s\n", RED, option, WHT, ". ", optionString);

endfunction