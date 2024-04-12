% extractNumbers.m


function [aa_length, aa_string ] = extractAA(inputString);

    global numPeaks

    if nargin == 0
        disp("")
        disp("Please enter any string as input");
        disp("")
        aa_length = 0;
        aa_string = "";
    else
        % keep only valid one-letter amino acid characters
        aa_array = regexpi(inputString, '[a|c-i|k-n|q-t|v|w|y]','match');
        % reshape into character string
        aa_string = strvcat(aa_array)';
        % check length, if needed append string "VACDEFGNSHIKLMQRTWY"
        aa_default = "VACDEFGNSHIKLMQRTWY";
        if length(aa_string) < 9 && aa_string > 0
            disp("That is a short sentence, but ok ...")
            numMissing = numPeaks - length(aa_string);
            aa_string = strcat(aa_string,aa_default(1:numMissing));
            aa_string = toupper(aa_string);
            aa_length = length(aa_string);
        elseif length(aa_string) == 0
            disp("")
            disp("I couldn't find any characters from a to z...")
            disp("")
            aa_length = 0;
            aa_string = "";
        else
            aa_string = toupper(aa_string(1:numPeaks));
            aa_length = length(aa_string);
        end
        % check redundacy of string!
        maxNumSame = 0;
        badAA = "";
        for aa_type = ["A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y"]
            numRes = length(find(aa_string == aa_type));
            if numRes > maxNumSame
                maxNumSame = numRes;
                badAA = aa_type;
            end
        end
        if maxNumSame > 3
            disp("")
            printf("Oosh, those are too many %s's...\n", badAA);
            disp("")
            aa_length = 0;
            aa_string = "";
        end
    end

endfunction

