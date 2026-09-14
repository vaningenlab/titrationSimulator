% defineMusic.m

% define retro game music
fs = 8000;				% dwell time / 8 kHz max
noteDur = 0.125;	    % 125 ms duration 1/16 note = 1 beat per 500 ms = 120 BPM
						% 1 bar = 4*0.5 = 2 sec
t16 = 0:1/fs:noteDur;	% time vector sixteenth note
t8  = 0:1/fs:noteDur*2;	% time vector eight note
t4  = 0:1/fs:noteDur*4;	% time vector quarter note = 0.6 sec
t2  = 0:1/fs:noteDur*8;	% time vector half note
t1  = 0:1/fs:noteDur*16; % time vector full note

% Note frequencies (Hz)
Q  = 0; % silent note
C3 = 130.81;    %3rd octave
D3 = 146.83;
E3m = 155.56;
E3 = 164.81;
F3 = 174.61;
G3 = 196.00; 
A3m = 207.65;
A3 = 220.00;
B3 = 246.94;

C4 = 261.63;
D4 = 293.66;
E4m = 311.13;
E4 = 329.63;
F4 = 349.23;
G4 = 392.00;
A4 = 440.00;
B4 = 493.88;

C5 = 523.25;
D5 = 587.33;
E5 = 659.25;

% --- Intro sequence - 12 sec = 5 bars using 4x quarter notes (4x0.6=2.4sec)
intro  = [ G3 Q Q E3 Q C3 Q ... 
           G3 Q C3 Q ...
           E3 Q C3 Q ...
           G3 Q C3 Q ...
           E3 Q G3 A3];

% --- Boot succes sequence - 5 sec = 2.5 bars using 40 sixteenth notes (40x0.125sec)
boot   = [Q Q E3m Q E3m Q E3m Q E3m Q E3m Q ];

melody = [E3m Q   Q   C3  Q   Q   G3  Q  Q  Q   ...
          E3m Q   Q   C3  Q   Q   G3  Q  Q  Q   ...
          F3  Q   Q   D3  Q   Q   A3m  Q  Q  Q   ...
          F3  Q   Q   D3  Q   Q   A3m  Q  Q  Q   ...
          E3m Q   Q   C3  Q   Q   G3  Q  Q  Q   ...
          E3m Q   Q   C3  Q   Q   G3  Q  Q  Q   ...
          F3  Q   Q   D3  Q   Q   A3m  Q  Q  Q   ...
          F3  Q   Q   D3  Q   Q   A3m  Q  Q  Q   ...
          E3m Q   C3  Q   G3  Q   E3m Q  C3 G3  ...
          F3  Q   D3  Q   A3m Q   F3  Q  D3 A3m ...
          E3m Q   C3  Q   G3  Q   E3m Q  C3 G3  ...
          D3  F3  A3m D3  F3  A3m D3  F3  A3m G3 ...
          C3  E3m G3  D3  F3  A3m C3  E3m G3 A3m];

succes   = [A3m Q A3m Q A3m Q A3m Q A3m Q];

% --- Chords --- Cmaj, Amin, Cmaj, Fmaj, Bdim, 16x half notes = 16 sec
chords = [ C4 E4 G4;    
	       C4 E4 G4;
           A4 C5 E5;
           Q Q Q;
           G4 C5 E5;
           G4 C5 E5;
           F4 A4 C5
           Q Q Q;

           C4 E4 G4;
	       C4 E4 G4;
           A4 C5 E5;
           Q Q Q;
           G4 C5 E5;
           G4 C5 E5;
           B4 D4 F4;
           B4 D4 F4;
];

% --- Bassline ---
bassNotes = [C3 C3 G3 G3 A3 A3 E3 E3 ...
             C3 C3 G3 G3 A3 A3 E3 E3];


% synth options:
% 0 = sine / 1 = square / 2 = saw
% harmonic add multiples of basenote
% amp controls volume of note
% LFO1 adds cos amplitude modulation
% LFO2 adds cos frequency modulation

% --- Intro sequence - 12 sec

introTrack = [];

for i = intro
	% generate tone with frequency f for time t, with shape 1 (squarewave) and 0 harmonics at 1 amplitude and 50 Hz LFO
    wave = synth(i,t4,1,0,1,50);
    % add envelope decay to also avoid "click" at end of note, 100 to 30%
    env= linspace(1,0.3,length(wave));
    introTrack = [ introTrack wave.* env];
end

% NMR boot melody - 5 sec

leadTrack = [];
soloTrack = [];

for b = boot
    % generate tone with frequency f for time t, with shape 0 (sine wave) and 1 harmonics at 1 amplitude, no LFO
    wave = synth(b,t8,0,1,0.7,0);
    % add envelope decay to also avoid "click" at end of note, 100 to 30%
    env = linspace(1,0.3,length(wave));
    leadTrack = [ leadTrack wave.* env];
end

for m = melody
	% generate tone with frequency f for time t, with shape 0 (sine wave) and 2 harmonics at 1 amplitude, no LFO
    wave = synth(m,t16,0,1,0.7,0);
    % add envelope decay to also avoid "click" at end of note, 100 to 30%
    env = linspace(1,0.3,length(wave));
    leadTrack = [ leadTrack wave.* env];
    soloTrack = [ soloTrack wave.* env];
end

for s = succes
    % generate tone with frequency f for time t, with shape 0 (sine wave) and 1 harmonics at 1 amplitude, no LFO
    wave = synth(s,t8,0,1,0.7,0);
    % add envelope decay to also avoid "click" at end of note, 100 to 30%
    env = linspace(1,0.3,length(wave));
    leadTrack = [ leadTrack wave.* env];
end


soloTrack = [soloTrack soloTrack];
env= linspace(1,0.0,length(soloTrack));
soloTrack = soloTrack.*env;



chordTrack = [];

for i = 1:length(chords)

	% get chord and intialize wave
    chord = chords(i,:);
    chord_wave = zeros(1,length(t2));

    for k = 1:3
    	% generate tone with frequency f for time t, with shape 1 (sine wave) and 3 harmonics at 1 amplitude, no LFO
        wave = synth(chord(k),t2,0,1,1,0);;
       chord_wave = chord_wave + wave;
    end

    % rescale to amplitude 1 and set overall loudness
	chord_wave = chord_wave ./max(abs(chord_wave));

	% combine sound into chordTrack
    chordTrack = [ chordTrack chord_wave ];

end

bassTrack = [];

for f = bassNotes
    tb = 0:1/fs:(noteDur*2);            % bass note twice as long
    wave = synth(f,tb,0,0,0.5,0);       % keep bass at 50% volume, no decay, no pause for smooth bassline
    bassTrack = [bassTrack wave];
end

