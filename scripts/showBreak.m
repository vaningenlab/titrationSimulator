% showBreak.m

% Foreground colours (bold) -- this switch colors of next text immediately
 ESC  = char(27);
 MAG  = [ESC '[1;35m'];
 WHT  = [ESC '[1;37m' ESC '[0m'];

 printf("%s", MAG)
 junk=input("<>","s");
 printf("%s", WHT)