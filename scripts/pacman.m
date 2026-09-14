% pacman.m  –  Playable Pac-Man in the GNU Octave terminal
%
% Controls:  Arrow keys or WASD to move   |   Q to quit
%
% HOW IT WORKS
%   Octave has no non-blocking keyboard input, so we launch a tiny
%   Python helper in the background.  It reads raw keypresses and
%   writes the latest direction to a temp file.  The game loop polls
%   that file every frame (~80 ms), giving responsive controls.
%
% REQUIREMENTS
%   • GNU Octave 6+  (older versions should work too)
%   • Python 3  (ships with every modern Linux / macOS)
%   • A terminal that supports ANSI escape codes
%
% RUN:  octave --norc pacman.m
%       (or  source 'pacman.m'  inside an Octave session)

function pacman()

  %% ── ANSI / terminal helpers ────────────────────────────────────────
  ESC      = char(27);
  CLEAR    = [ESC '[2J'  ESC '[H'];
  HIDE_CUR = [ESC '[?25l'];
  SHOW_CUR = [ESC '[?25h'];
  RST      = [ESC '[0m'];

  YEL = [ESC '[1;33m'];   % Pac-Man
  RED = [ESC '[1;31m'];   % Blinky
  CYN = [ESC '[1;36m'];   % Inky
  MAG = [ESC '[1;35m'];   % Pinky
  BLU = [ESC '[1;34m'];   % frightened ghosts
  WHT = [ESC '[1;37m'];   % walls / dots
  GRN = [ESC '[1;32m'];   % power pellets
  DIM = [ESC '[2;37m'];   % eaten cells

  goto = @(r,c) fprintf('%s[%d;%dH', ESC, r, c);
  put  = @(r,c,col,ch) fprintf('%s[%d;%dH%s%s%s', ESC,r,c, col,ch, RST);

  %% ── Maze definition ────────────────────────────────────────────────
  % Each cell: 0=open 1=wall 2=dot 3=power-pellet 4=ghost-house
  % 21 cols × 11 rows  (small but full-featured)
  RAW = [
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ;
    1 2 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 1 ;
    1 3 1 1 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 3 1 ;
    1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 ;
    1 2 1 1 2 1 2 1 1 1 1 1 1 1 2 1 2 1 1 2 1 ;
    1 2 2 2 2 1 2 2 2 1 4 4 1 2 2 2 2 2 2 2 1 ;
    1 2 1 1 2 1 1 1 2 1 4 4 1 2 1 1 1 2 1 2 1 ;
    1 2 1 1 2 1 2 2 2 2 2 2 2 2 2 1 2 2 1 2 1 ;
    1 2 2 2 2 2 2 1 1 1 1 1 1 1 2 2 2 2 2 2 1 ;
    1 2 1 1 2 2 2 2 2 1 1 1 2 2 2 2 2 1 1 2 1 ;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ;
  ];

  ROWS = size(RAW, 1);
  COLS = size(RAW, 2);

  % find all dot / pellet positions for reset
  INIT_MAZE = RAW;

  %% ── Ghost house spawn positions ────────────────────────────────────
  GHOST_START = [6 11; 6 10; 6 12; 5 11];   % row,col for each ghost
  GHOST_COLS  = {RED; CYN; MAG; YEL};        % reuse YEL for 4th (orange)

  %% ── Screen layout ──────────────────────────────────────────────────
  %  Row 1        : title
  %  Rows 2..R+1  : maze  (maze row r → screen row r+1)
  %  Row R+3      : status bar
  SCR_OFF = 1;   % maze screen row = maze_row + SCR_OFF

  %% ── Start the Python key-reader ────────────────────────────────────
  keyfile = tempname();

  % Write a tiny Python script to a temp file so we don't fight quoting
  pyfile = tempname();
  fid = fopen(pyfile, 'w');
  fprintf(fid, [
    "import sys, os, tty, termios, signal\n"
    "kf = sys.argv[1]\n"
    "fd = sys.stdin.fileno()\n"
    "old = termios.tcgetattr(fd)\n"
    "def restore(sig=None,frm=None):\n"
    "    termios.tcsetattr(fd,termios.TCSADRAIN,old)\n"
    "    sys.exit(0)\n"
    "signal.signal(signal.SIGTERM, restore)\n"
    "tty.setraw(fd)\n"
    "MAP = {b'\\x1b[A':'U',b'\\x1b[B':'D',b'\\x1b[C':'R',b'\\x1b[D':'L',\n"
    "       b'w':'U',b's':'D',b'd':'R',b'a':'L',\n"
    "       b'W':'U',b'S':'D',b'D':'R',b'A':'L',\n"
    "       b'q':'Q',b'Q':'Q'}\n"
    "while True:\n"
    "    ch = os.read(fd,1)\n"
    "    if ch == b'\\x1b':\n"
    "        try: ch += os.read(fd,2)\n"
    "        except: pass\n"
    "    k = MAP.get(ch)\n"
    "    if k:\n"
    "        open(kf,'w').write(k)\n"
    "    if k == 'Q': restore()\n"
  ]);
  fclose(fid);

  % Launch Python in background; capture its PID
  cmd = sprintf('python3 %s %s </dev/tty &>/dev/null & echo $!', pyfile, keyfile);
  [~, pid_str] = system(cmd);
  py_pid = str2num(strtrim(pid_str));

  %% ── Game state ─────────────────────────────────────────────────────
  function s = new_game()
    s.maze      = INIT_MAZE;
    s.pac_r     = 9;  s.pac_c = 11;   % Pac-Man start
    s.pac_dir   = [0 0];              % not moving
    s.pac_next  = [0 0];
    s.mouth     = true;
    s.lives     = 3;
    s.score     = 0;
    s.frame     = 0;
    s.fright     = 0;                 % frightened countdown
    s.last_key  = 'R';               % last valid direction key

    % Ghosts: [row col dir_r dir_c frightened eaten]
    s.gh = zeros(4,6);
    for gi = 1:4
      s.gh(gi,1) = GHOST_START(gi,1);
      s.gh(gi,2) = GHOST_START(gi,2);
      s.gh(gi,3) = 0; s.gh(gi,4) = 1;  % start moving right
    end
  end

  %% ── Drawing helpers ────────────────────────────────────────────────
  function draw_cell(r, c, maze)
    sr = r + SCR_OFF;
    sc = c * 2 - 1;   % 2 chars per cell
    v  = maze(r,c);
    switch v
      case 1,  put(sr, sc, WHT, '██');
      case 2,  put(sr, sc, DIM, ' ·');
      case 3,  put(sr, sc, GRN, ' ●');
      case 4,  put(sr, sc, DIM, '  ');
      otherwise, put(sr, sc, RST, '  ');
    end
  end

  function draw_maze(maze)
    for r = 1:ROWS
      for c = 1:COLS
        draw_cell(r, c, maze);
      end
    end
  end

  function draw_pac(s)
    sr = s.pac_r + SCR_OFF;
    sc = s.pac_c * 2 - 1;
    if s.mouth
      % choose glyph based on direction
      dr = s.pac_dir(1); dc = s.pac_dir(2);
      if     dc >  0, g = 'ᗤ ';
      elseif dc <  0, g = ' ᗧ';
      elseif dr <  0, g = 'ᗦ ';
      elseif dr >  0, g = 'ᗥ ';
      else,           g = 'ᗤ ';
      end
    else
      g = 'ᗧ ';
    end
    put(sr, sc, YEL, g);
  end

  function erase_pac(s)
    draw_cell(s.pac_r, s.pac_c, s.maze);
  end

  function draw_ghost(gi, s)
    r  = s.gh(gi,1);  c  = s.gh(gi,2);
    sr = r + SCR_OFF; sc = c * 2 - 1;
    if s.gh(gi,5)         % frightened
      col = BLU;
    else
      col = GHOST_COLS{gi};
    end
    if mod(s.frame,6) < 3, g = 'ᗣ '; else, g = 'ᗤ '; end
    put(sr, sc, col, g);
  end

  function erase_ghost(gi, s)
    draw_cell(s.gh(gi,1), s.gh(gi,2), s.maze);
  end

  function draw_status(s)
    goto(ROWS + SCR_OFF + 2, 1);
    fprintf('%sScore:%-6d  Lives:%s%s', WHT, s.score, ...
            repmat('♥ ', 1, s.lives), RST);
  end

  function draw_all(s)
    fprintf('%s', CLEAR);
    goto(1,1);
    fprintf('%s  PAC-MAN  –  Arrows/WASD move  |  Q quit%s', YEL, RST);
    draw_maze(s.maze);
    draw_pac(s);
    for gi = 1:4; draw_ghost(gi,s); end
    draw_status(s);
    fflush(stdout);
  end

  %% ── Ghost AI: simple "chase or scatter" ────────────────────────────
  function [nr,nc] = ghost_move(gi, s)
    r  = s.gh(gi,1); c  = s.gh(gi,2);
    dr = s.gh(gi,3); dc = s.gh(gi,4);

    % candidate moves in priority order (no 180° reversal)
    dirs = [-1 0; 0 1; 1 0; 0 -1];
    rev  = [-dr -dc];

    % pick target
    if s.fright > 0
      % random walk when frightened
      perm = dirs(randperm(4), :);
      for k = 1:4
        nd = perm(k,:);
        if isequal(nd, rev); continue; end
        tr = r + nd(1); tc = c + nd(2);
        if tr>=1&&tr<=ROWS&&tc>=1&&tc<=COLS && s.maze(tr,tc)~=1
          nr=tr; nc=tc; s.gh(gi,3)=nd(1); s.gh(gi,4)=nd(2);
          return;
        end
      end
    else
      % chase Pac-Man (greedy best-first)
      best_d = Inf; nr=r; nc=c;
      best_dr=dr; best_dc=dc;
      for k = 1:4
        nd = dirs(k,:);
        if isequal(nd, rev); continue; end
        tr = r + nd(1); tc = c + nd(2);
        if tr>=1&&tr<=ROWS&&tc>=1&&tc<=COLS && s.maze(tr,tc)~=1
          d = (tr-s.pac_r)^2 + (tc-s.pac_c)^2;
          if d < best_d
            best_d=d; nr=tr; nc=tc; best_dr=nd(1); best_dc=nd(2);
          end
        end
      end
      s.gh(gi,3)=best_dr; s.gh(gi,4)=best_dc;
      return;
    end
    nr=r; nc=c;
  end

  %% ── Read latest keypress from file ─────────────────────────────────
  function k = read_key()
    k = '';
    if exist(keyfile, 'file')
      fid2 = fopen(keyfile,'r');
      if fid2 > 0
        k = fgetl(fid2);
        fclose(fid2);
        if ~ischar(k); k=''; end
      end
    end
  end

  %% ── Direction helpers ───────────────────────────────────────────────
  function [dr,dc] = key_to_dir(k)
    switch k
      case 'U', dr=-1; dc= 0;
      case 'D', dr= 1; dc= 0;
      case 'L', dr= 0; dc=-1;
      case 'R', dr= 0; dc= 1;
      otherwise, dr=0; dc=0;
    end
  end

  %% ── Death / level-complete animations ──────────────────────────────
  function death_anim(s)
    seqs = {'ᗤ ','ᗧ ','C ','c ','( ','· ','  '};
    for i = 1:numel(seqs)
      sr = s.pac_r + SCR_OFF; sc = s.pac_c*2-1;
      put(sr, sc, YEL, seqs{i});
      fflush(stdout);
      pause(0.12);
    end
  end

  %% ════════════════════════════════════════════════════════════════════
  %%  MAIN GAME
  %% ════════════════════════════════════════════════════════════════════
  fprintf('%s%s', HIDE_CUR, CLEAR);

  s = new_game();
  draw_all(s);

  TICK = 0.08;   % seconds per frame

  unwind_protect

    running = true;
    while running && s.lives > 0

      s.frame++;
      s.mouth = ~s.mouth;
      if s.fright > 0; s.fright--; end

      %% ── Input ──────────────────────────────────────────────────────
      k = read_key();
      if strcmp(k,'Q'); running=false; break; end

      if ~isempty(k) && any(strcmp(k,{'U','D','L','R'}))
        s.last_key = k;
      end

      % try queued direction, then last held direction
      [dr,dc] = key_to_dir(s.last_key);
      nr = s.pac_r + dr; nc = s.pac_c + dc;
      % wrap tunnel (row 6, cols 1 and 21)
      nc = mod(nc-1, COLS)+1;
      if nr>=1&&nr<=ROWS && s.maze(nr,nc)~=1
        s.pac_dir = [dr dc];
        erase_pac(s);
        s.pac_r = nr; s.pac_c = nc;
      end

      %% ── Eat dots / pellets ─────────────────────────────────────────
      cell_v = s.maze(s.pac_r, s.pac_c);
      if cell_v == 2
        s.score += 10;
        s.maze(s.pac_r, s.pac_c) = 0;
      elseif cell_v == 3
        s.score += 50;
        s.maze(s.pac_r, s.pac_c) = 0;
        s.fright = 30;   % ~2.4 s of frightened ghosts
        for gi=1:4; s.gh(gi,5)=1; end
      end

      %% ── Move ghosts ────────────────────────────────────────────────
      for gi = 1:4
        % ghosts move every 2nd frame (slightly slower than Pac-Man)
        if mod(s.frame + gi, 2) == 0
          erase_ghost(gi, s);
          [nr2,nc2] = ghost_move(gi, s);
          s.gh(gi,1) = nr2; s.gh(gi,2) = nc2;
        end
        if s.fright == 0; s.gh(gi,5) = 0; end
      end

      %% ── Collision detection ────────────────────────────────────────
      dead = false;
      for gi = 1:4
        if s.gh(gi,1)==s.pac_r && s.gh(gi,2)==s.pac_c
          if s.gh(gi,5)          % ghost is frightened → eat it
            s.score += 200;
            s.gh(gi,1) = GHOST_START(gi,1);
            s.gh(gi,2) = GHOST_START(gi,2);
            s.gh(gi,5) = 0;
          else                   % Pac-Man dies
            dead = true;
          end
        end
      end

      %% ── Draw frame ─────────────────────────────────────────────────
      draw_pac(s);
      for gi=1:4; draw_ghost(gi,s); end
      draw_status(s);
      fflush(stdout);

      %% ── Handle death ───────────────────────────────────────────────
      if dead
        death_anim(s);
        s.lives--;
        if s.lives > 0
          pause(0.5);
          s.pac_r=9; s.pac_c=11;
          s.pac_dir=[0 0]; s.last_key='R';
          for gi=1:4
            s.gh(gi,1)=GHOST_START(gi,1);
            s.gh(gi,2)=GHOST_START(gi,2);
            s.gh(gi,3)=0; s.gh(gi,4)=1; s.gh(gi,5)=0;
          end
          draw_all(s);
        end
      end

      %% ── Check level clear ──────────────────────────────────────────
      if ~any(any(s.maze == 2)) && ~any(any(s.maze == 3))
        goto(ROWS + SCR_OFF + 3, 1);
        fprintf('%s  *** LEVEL CLEAR!  Score: %d ***%s\n', GRN, s.score, RST);
        fflush(stdout);
        pause(2);
        s.maze = INIT_MAZE;
        s.pac_r=9; s.pac_c=11;
        s.pac_dir=[0 0]; s.last_key='R';
        for gi=1:4
          s.gh(gi,1)=GHOST_START(gi,1);
          s.gh(gi,2)=GHOST_START(gi,2);
          s.gh(gi,3)=0; s.gh(gi,4)=1; s.gh(gi,5)=0;
        end
        draw_all(s);
      end

      pause(TICK);
    end   % main loop

    % Game-over screen
    goto(ROWS + SCR_OFF + 3, 1);
    fprintf('%s  GAME OVER  –  Final score: %d%s\n', RED, s.score, RST);
    fflush(stdout);
    pause(2);

  unwind_protect_cleanup
    % Kill the Python key-reader
    if ~isempty(py_pid) && py_pid > 0
      system(sprintf('kill %d 2>/dev/null', py_pid));
    end
    delete(keyfile);
    delete(pyfile);
    % Restore terminal
    goto(ROWS + SCR_OFF + 5, 1);
    fprintf('%s', SHOW_CUR);
    system('stty sane');
  end_unwind_protect

end
