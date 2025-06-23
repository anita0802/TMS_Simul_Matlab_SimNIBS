function v = tetvol(P, T)
%   SNM 2021, After P. O. Persson
  d12 = P(T(:, 2), :)- P(T(:, 1), :);
  d13 = P(T(:, 3), :)- P(T(:, 1), :);
  d14 = P(T(:, 4), :)- P(T(:, 1),:);
  v = abs(dot(cross(d12, d13, 2), d14, 2))/6;   % with abs here!
end
