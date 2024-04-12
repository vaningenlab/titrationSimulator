% extractNumbers.m


function [vector, array ] = extractNumbers(inputString);

    if nargin == 0
        disp("")
        disp("Please enter any number containing string as input");
        disp("")
        vector = 0;
    else
        % take first word from input
        wordList = strsplit(strtrim(inputString), " ");
        % remove any non-digit symbols
        justNumbers = regexprep(wordList{1}, '\D',"");
        % truncate to 8 numbers if more
        if length(justNumbers) > 8
            justNumbers = justNumbers(1:8);
        end
        % split each digit into cell-array m
        [s, q, te, m, t, nm] = regexp(justNumbers, '\d');
        vector = str2double(m);
        array = m;
        % vector should have at least 8 elements
        if length(vector) < 8
            disp("")
            disp("Oosh, I didn't find enough numbers ...")
            disp("")
            vector =0;
        end
        % sum of vector should be at least 01/01/2000 = 4
        % sum of vector is at most 29/09/1999 = 48
        if sum(vector) < 4 || sum(vector) > 48
            disp("")
            disp("This does not look like a real date ...")
            disp("")
            vector =0;
        end
    end

endfunction

