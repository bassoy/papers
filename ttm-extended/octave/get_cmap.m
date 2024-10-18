function cmap = get_cmap()
  colors = [
    0, 0, 77;       % Deep Blue (Darkest)
    0, 0, 102;      % Navy Blue
    0, 0, 128;      % Dark Blue
    0, 0, 153;      % Sapphire Blue
    0, 0, 204;      % True Blue
    0, 0, 255;      % Pure Blue
    51, 51, 255;    % Bright Blue
    77, 77, 255;    % Vivid Blue
    102, 102, 255;  % Sky Blue
    %128, 128, 255   % Light Blue (Lightest)
    211, 211, 211;   % gray
    211, 211, 211;   % gray
    %255, 102, 102;   % Light Red
    255, 77, 77;     % Bright Red
    255, 51, 51;     % Scarlet
    255, 26, 26;     % Cherry Red
    255, 0, 0;       % Pure Red
    204, 0, 0;       % Dark Red
    153, 0, 0;       % Crimson
    128, 0, 0;       % Burgundy
    102, 0, 0;       % Wine
    77, 0, 0        % Deep Red
  ] ./ 255;  % Normalize to [0, 1]
  ncolors=size(colors,1);
  onecolor=100;
  cmap = zeros(onecolor*ncolors,3);

  k=1:onecolor;
  for i=1:ncolors
    b = (i-1)*onecolor;
    cmap(b+k,:) = repmat(colors(i,:),onecolor, 1);
  end

  b = (9-1)*onecolor;
  k=1:90;  cmap(b+k,:) = repmat(colors( 9,:),k(end), 1); b+=k(end);
  k=1:110; cmap(b+k,:) = repmat(colors(10,:),k(end), 1); b+=k(end);
  k=1:110; cmap(b+k,:) = repmat(colors(11,:),k(end), 1); b+=k(end);
  k=1:90;  cmap(b+k,:) = repmat(colors(12,:),k(end), 1);

end
