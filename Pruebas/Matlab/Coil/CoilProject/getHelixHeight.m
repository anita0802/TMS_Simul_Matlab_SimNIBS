function altura = getHelixHeight(turns, pitch)
% coilHeight - Calcula la altura axial real de una bobina helicoidal

    if turns == 0
        fprintf('Hay una hélice con número de vueltas igual a 0 \n');
    end

    altura = turns * pitch;
end