% dispCommand.m

function formattedCommand=dispCommand(commandString)

	ESC  = char(27);   
 	RED  = [ESC '[1;31m'];
 	WHT  = [ESC '[1;37m' ESC '[0m'];

 	formattedCommand = sprintf("%s%s%s", RED, commandString, WHT);

endfunction