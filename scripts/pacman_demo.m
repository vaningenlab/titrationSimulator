% pacman_demo.m
% Pac-Man terminal animation for GNU Octave
% Run with: octave --norc pacman_demo.m
% Or inside Octave: pacman_demo
% by Claude AI

function pacman_demo()
  % --- ANSI escape helpers ---
  ESC       = char(27);
  CLEAR     = [ESC '[2J' ESC '[H'];          % clear screen + home cursor
  HIDE_CUR  = [ESC '[?25l'];                 % hide cursor
  SHOW_CUR  = [ESC '[?25h'];                 % restore cursor
  RESET_COL = [ESC '[0m'];

  % Foreground colours (bold) -- this switch colors of next text immediately
  YEL  = [ESC '[1;33m'];   % Pac-Man
  RED  = [ESC '[1;31m'];   % Blinky
  CYN  = [ESC '[1;36m'];   % Inky
  MAG  = [ESC '[1;35m'];   % Pinky
  WHT  = [ESC '[1;37m'];   % dots / walls
  BLU  = [ESC '[1;34m'];   % walls accent
  DIM  = [ESC '[2;37m'];   % eaten dots

  % ---- tunnel layout (21 cols x 5 rows) ----
  TUNNEL_W = 42;   % chars wide (2 chars per cell)
  TUNNEL_H = 5;

  % dots along the middle row
  n_dots   = 18;
  dot_cols = round(linspace(3, TUNNEL_W - 2, n_dots));

  % ghosts: [col, colour_string]  (start off-screen right)
  ghosts = { TUNNEL_W + 4,  RED,  'R'; ...
             TUNNEL_W + 14, CYN,  'I'; ...
             TUNNEL_W + 24, MAG,  'P' };
  n_ghosts = size(ghosts, 1);

  ghost_col  = cellfun(@(x) x, ghosts(:,1));   % current cols
  ghost_char = {'ᗣ', 'ᗣ', 'ᗣ'};              % ghost glyph

  % Pac-Man state
  pac_col    = 1;
  mouth_open = true;
  eaten      = false(1, n_dots);  % which dots consumed

  % score
  score = 0;

  % ---- draw static tunnel walls ----
  function walls = make_walls()
    top    = [WHT '╔' repmat('═', 1, TUNNEL_W) '╗' RESET_COL];
    bottom = [WHT '╚' repmat('═', 1, TUNNEL_W) '╝' RESET_COL];
    mid    = [WHT '║' repmat(' ', 1, TUNNEL_W) '║' RESET_COL];
    walls  = {top; mid; mid; mid; bottom};
  end

  % ---- move cursor to (row, col) 1-indexed ----
  function goto(r, c)
    fprintf('%s[%d;%dH', ESC, r, c);
  end

  % ---- draw a single character at screen position ----
  function put(r, c, colour, ch)
    goto(r, c);
    fprintf('%s%s%s', colour, ch, RESET_COL);
  end

  % ---- initial full draw ----
  function full_draw(walls)
    fprintf('%s', CLEAR);
    % title
    goto(1, 1);
    fprintf('%s  PAC-MAN  –  GNU Octave Terminal Demo%s\n', YEL, RESET_COL);
    % walls
    for row = 1:TUNNEL_H
      goto(row + 1, 1);
      fprintf('%s', walls{row});
    end
    % score line
    goto(TUNNEL_H + 3, 1);
    fprintf('%sScore: 0%s', WHT, RESET_COL);
  end

  % ---- Pac-Man glyph (open/closed, direction) ----
  function g = pac_glyph(open)
    if open
      g = 'ᗤᗧ';   % open mouth facing right U+15E4 : CANADIAN SYLLABICS CARRIER TTE
    else
      g = 'ᗡ';   % closed U+15E7 : CANADIAN SYLLABICS CARRIER TTA
    end
  end

  % ---- ghost glyph alternates for animation ----
  function g = ghost_glyph(frame)
    if mod(frame, 6) < 3
      g = 'ᗣ'; % ghost - U+15E3 : CANADIAN SYLLABICS CARRIER TTO
    else
      g = 'ᗤ';   % wiggle feet
    end
  end

  % =========================================================
  %  MAIN ANIMATION LOOP
  % =========================================================
  walls = make_walls();
  fprintf('%s%s', HIDE_CUR, CLEAR);
  full_draw(walls);

  TUNNEL_ROW = 4;   % screen row for the action (inside tunnel)
  SCREEN_OFF = 2;   % walls start at screen row 2

  PAC_SPEED   = 1;   % cols per frame
  GHOST_SPEED = 1;

  total_frames = 120;
  frame        = 0;

  unwind_protect
    while frame < total_frames
      frame++;

      % -- move Pac-Man --
      pac_col   = pac_col + PAC_SPEED;
      mouth_open = ~mouth_open;

      % erase old Pac-Man position (one col back)
      prev = pac_col - PAC_SPEED;
      if prev >= 1 && prev <= TUNNEL_W
        put(TUNNEL_ROW, prev + 1, DIM, ' ');
      end

      % check dot eating
      for d = 1:n_dots
        if ~eaten(d) && pac_col >= dot_cols(d)
          eaten(d) = true;
          score    = score + 10;
          % erase dot
          put(TUNNEL_ROW, dot_cols(d) + 1, DIM, ' ');
          % update score
          goto(TUNNEL_H + 3, 1);
          fprintf('%sScore: %d   %s', WHT, score, RESET_COL);
        end
      end

      % draw Pac-Man
      if pac_col >= 1 && pac_col <= TUNNEL_W
        put(TUNNEL_ROW, pac_col + 1, YEL, pac_glyph(mouth_open));
      end

      % -- move & draw ghosts --
      for g = 1:n_ghosts
        old_gc = ghost_col(g);
        ghost_col(g) = ghost_col(g) - GHOST_SPEED;
        gc = ghost_col(g);

        % erase old ghost position
        if old_gc >= 1 && old_gc <= TUNNEL_W
          % restore dot if it was there
          dot_here = find(dot_cols == old_gc & ~eaten, 1);
          if ~isempty(dot_here)
            put(TUNNEL_ROW, old_gc + 1, WHT, '·');
          else
            put(TUNNEL_ROW, old_gc + 1, DIM, ' ');
          end
        end

        % draw ghost
        if gc >= 1 && gc <= TUNNEL_W
          colours = {RED; CYN; MAG};
          put(TUNNEL_ROW, gc + 1, colours{g}, ghost_glyph(frame));
        end
      end

      % -- draw dots that haven't been eaten yet --
      for d = 1:n_dots
        if ~eaten(d)
          dc = dot_cols(d);
          % only redraw if nothing is on top
          occupied = (pac_col == dc);
          for g = 1:n_ghosts
            if ghost_col(g) == dc; occupied = true; end
          end
          if ~occupied
            put(TUNNEL_ROW, dc + 1, WHT, '·');
          end
        end
      end

      fflush(stdout);
      pause(0.07);

      % -- reset when Pac-Man leaves the tunnel --
      if pac_col > TUNNEL_W + 2
        pause(0.4);
        pac_col    = 0;
        ghost_col  = [TUNNEL_W + 4; TUNNEL_W + 14; TUNNEL_W + 24];
        eaten(:)   = false;
        mouth_open = true;

        % redraw dots
        for d = 1:n_dots
          put(TUNNEL_ROW, dot_cols(d) + 1, WHT, '·');
        end
        pause(0.3);
      end
    end

  unwind_protect_cleanup
    % always restore cursor & show a newline
    goto(TUNNEL_H + 5, 1);
    fprintf('%s\nFinal score: %d\n', SHOW_CUR, score);
  end_unwind_protect
end
