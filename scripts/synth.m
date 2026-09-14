% synth.m
% waveform generator
% add in frequency modulation for full madness!

function tone = synth(frequency, time_v, shape, harmonic, amp, LFO)

	if shape == 0
		% sine wave
		tone1 = sin(2*pi*frequency*time_v);
		tone2 = tone1;
		for k = 1:harmonic
			tone2 = tone2 + sin(2*pi*k*frequency*time_v);
		end
	elseif shape == 1
		% square wave
		tone1 = sign(sin(2*pi*frequency*time_v));
		tone2 = tone1;
		for k = 1:harmonic
			tone2 = tone2 + sign(sin(2*pi*k*frequency*time_v));
		end
	else
		% sawtooth
		tone1 = atan(tan(2*pi*frequency*time_v));
		tone2 = tone1;
		for k = 1:harmonic
			tone2 = tone2 + atan(tan(2*pi*k*frequency*time_v));
		end
	end
	% add LFO on amplitude, LFO = 0 is *1
	tone2 = tone2.*cos(2*pi*LFO*time_v);
	% rescale to amplitude 1 and set overall loudness
	tone = tone2 ./max(abs(tone2));
	tone = amp.*tone2;

end