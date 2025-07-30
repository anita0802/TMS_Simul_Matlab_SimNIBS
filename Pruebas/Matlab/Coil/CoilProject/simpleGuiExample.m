function addNewCoil()
    % Crear una ventana para introducir los parámetros
    fig = uifigure('Name', 'Añadir Nueva Bobina', 'Position', [100, 100, 350, 300]);
    
    % Crear campos para los parámetros de la bobina
    uilabel(fig, 'Position', [10, 250, 150, 20], 'Text', 'Nombre de la bobina:');
    coilNameField = uieditfield(fig, 'text', 'Position', [150, 250, 150, 20]);
    
    uilabel(fig, 'Position', [10, 210, 150, 20], 'Text', 'Tiempo de bajada (s):');
    fallTimeField = uieditfield(fig, 'numeric', 'Position', [150, 210, 150, 20]);
    
    uilabel(fig, 'Position', [10, 170, 150, 20], 'Text', 'Vueltas hélice exterior:');
    turns1Field = uieditfield(fig, 'numeric', 'Position', [150, 170, 150, 20]);
    
    uilabel(fig, 'Position', [10, 130, 150, 20], 'Text', 'Altura de la bobina (m):');
    heightField = uieditfield(fig, 'numeric', 'Position', [150, 130, 150, 20]);
    
    % Crear botón para confirmar la adición de la nueva bobina
    addButton = uibutton(fig, 'Text', 'Añadir Bobina', 'Position', [100, 50, 150, 30]);
    addButton.ButtonPushedFcn = @(src, event) addCoilData(coilNameField.Value, fallTimeField.Value, turns1Field.Value, heightField.Value);
    
    % Función para añadir la nueva bobina al script
    function addCoilData(coilName, t_fall, turns1, height)
        if isempty(coilName) || isempty(t_fall) || isempty(turns1) || isempty(height)
            uialert(fig, 'Por favor, complete todos los campos.', 'Error', 'Icon', 'error');
            return;
        end
        
        % Asignar los valores a la estructura coil
        coil = struct();
        coil.t_fall = t_fall;
        coil.wd = 0.0002;  % valor por defecto (puedes cambiarlo según sea necesario)
        coil.h = height;
        coil.L = 1e-6;     % valor por defecto (puedes cambiarlo según sea necesario)
        coil.turns1 = turns1;
        coil.radius1 = 0.00125;  % valor por defecto (puedes cambiarlo según sea necesario)
        coil.pitch1 = 0.0009;    % valor por defecto (puedes cambiarlo según sea necesario)
        coil.turns2 = 0;         % valor por defecto
        coil.radius2 = 0;        % valor por defecto
        coil.pitch2 = 0;         % valor por defecto
        
        % Guardar la bobina en un archivo mat
        save('coil.mat', 'coil');
        
        % Confirmación
        msg = sprintf('La bobina %s se ha añadido correctamente.', coilName);
        uialert(fig, msg, 'Éxito', 'Icon', 'success');
        
        % Cerrar la ventana
        close(fig);
    end
end
