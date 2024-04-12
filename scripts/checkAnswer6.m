% checkAnswer3.m
% for question with ABC option only (Q10)

function answer = checkAnswer6(inputString);

    if nargin == 0
        disp("")
        inputString = input("Enter your answer again: ","s");
        disp("")
    end
    % take first word from input
    answer = strsplit(strtrim(inputString), " ");
    % remove any non-letter/digit symbols
    answer = regexprep(answer{1}, '\W',"");
    % convert to uppercase
    answer = toupper(answer);
    % if answer is "A" "a"
    if length(regexprep(answer,"[ABCDEF]","")) > 0 || length(answer) == 0
        disp("")
        disp("Your answer should be A, B, C, D, E, or F.")
        disp("")
        inputString = input("Enter your answer again: ","s");
        disp("")
        answer = strsplit(strtrim(inputString), " ");
        answer = regexprep(answer{1}, '\W',"");
        answer = regexprep(answer, '\d', "");
        answer = toupper(answer);
        if length(regexprep(answer,"[ABCDEF]","")) > 0
            disp("")
            disp("That was still something else.")
            answer = "Z";
        end
    end

endfunction
