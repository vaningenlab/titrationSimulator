% typewriter.m
% write out text character by character with custom delay

function typewriter(str, delay)

	for k = 1:length(str)
	    printf("%s", str(k));
	    fflush(stdout);   % forces immediate display
	    pause(delay);
	end

end