% createAcronym.m


function acronym = createAcronym(inputString);

    if nargin == 0
        disp("")
        disp("Please enter any string as input");
        disp("")
        acronym = 0;
    else
        % take first word from input
        wordList = strsplit(strtrim(inputString), " ");
        % remove any non-letter/digit symbols
        wordInput = regexprep(wordList{1}, '\W',"");
        % remove any digit
        charInput = tolower(regexprep(wordInput, '\d', ""));
        % remove vowels and convert to uppercase
        acronym = toupper(regexprep(charInput,"[aeiou]",""));
        % check length
        if length(acronym) < 2
            % try to see if last name is there
            wordInput = regexprep(inputString, '\W',"");
            charInput = tolower(regexprep(wordInput, '\d', ""));
            acronym = toupper(regexprep(charInput,"[aeiou]",""));
            if length(acronym) < 2
                disp("")
                disp("It seems there are too few consonants left ...")
                disp("")
                acronym =0;
            end
        end
        % check redundacy of string! only relevant for amino acid sequence
        maxNumSame = 0;
        for l = ["B","C","D","F","G","H","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z"]
            numDouble = length(find(acronym == l));
            if numDouble > maxNumSame
                maxNumSame = numDouble;
                badl = l;
            end
        end
        if maxNumSame > 4
            disp("")
            printf("Oosh, those are too many %s's...\n", badl);
            disp("")
            acronym = 0;
        end
    end
    
endfunction

