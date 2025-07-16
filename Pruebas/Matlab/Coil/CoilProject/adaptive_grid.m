%% adaptive_grid.m: Función de muestreo adaptativo de inductancia con función handle
function samples = adaptive_grid(bounds, tol, maxDepth, eval_L_fn)
% adaptive_grid genera muestras adaptativas donde L varía
% Inputs:
%   bounds: struct con campos pitch1, pitch2, Lcore, wire_d, r1, cada uno [min, max]
%   tol: tolerancia de ΔL para subdividir (en Henrios)
%   maxDepth: profundidad máxima de recursión
%   eval_L_fn: función handle @(vec) que devuelve L para vec=[p1,p2,Lc,wd,r1]

    samples = [];
    function subdivide(b, depth)
        flds = fieldnames(b);
        % Generar esquinas y punto medio
        [G{1:5}] = ndgrid(...
          linspace(b.pitch1(1),b.pitch1(2),2), ...
          linspace(b.pitch2(1),b.pitch2(2),2), ...
          linspace(b.Lcore(1), b.Lcore(2),2), ...
          linspace(b.wire_d(1),b.wire_d(2),2), ...
          linspace(b.r1(1),    b.r1(2),    2));
        pts = cell2mat(cellfun(@(x)x(:), G, 'uni',0));
        mid = [ mean(b.pitch1), mean(b.pitch2), mean(b.Lcore), ...
                mean(b.wire_d),  mean(b.r1) ];
        P   = [pts; mid];
        % Evaluar L en cada punto usando eval_L_fn
        Lvals = arrayfun(@(i) eval_L_fn(P(i,:)), 1:size(P,1));
        % Decide subdividir
        if depth>0 && (max(Lvals)-min(Lvals))>tol
            for mask=0:(2^5-1)
                subb = b;
                for d=1:5
                    lohi = b.(flds{d}); mid_d = mean(lohi);
                    if bitget(mask,d)
                        subb.(flds{d}) = [mid_d, lohi(2)];
                    else
                        subb.(flds{d}) = [lohi(1), mid_d];
                    end
                end
                subdivide(subb, depth-1);
            end
        else
            % Guardar punto medio y su L
            samples(end+1,:) = [mid, Lvals(end)]; %#ok<AGROW>
        end
    end

    subdivide(bounds, maxDepth);
    samples = array2table(samples, ...
      'VariableNames', {'pitch1','pitch2','Lcore','wire_d','r1','L'});
end