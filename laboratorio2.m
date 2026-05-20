% Laboratorio 2: Diferencia de población
clear; clc;

% --- Variables e inicialización ---
a = 0;             
b = 20;            
B0 = 25;           

% Definimos la función B'(t)
B_prime = @(t) (30 * exp(-0.1 * t)) ./ (1 + 3 * exp(-0.1 * t)).^2;

% Calculamos el resultado analítico exacto
F_analitica = @(t) 100 ./ (1 + 3 * exp(-0.1 * t));
valor_exacto = F_analitica(b) - F_analitica(a);

% --- Ejecución de los métodos y generación de la tabla ---
fprintf('Valor exacto de la integral: %.6f\n\n', valor_exacto);

% Ajustamos las cabeceras para incluir las columnas de error
fprintf('%-4s | %-12s | %-14s | %-14s | %-14s\n', 'n', 'Trapecio', 'Err. Trap (%)', 'Simpson 1/3', 'Err. Simp (%)');
fprintf('------------------------------------------------------------------------\n');

for n = 2:10
    % --- 1. Cálculo con la Regla del Trapecio ---
    h_t = (b - a) / n;
    t_t = linspace(a, b, n + 1);
    y_t = B_prime(t_t);
    I_trap = (h_t / 2) * (y_t(1) + 2 * sum(y_t(2:end-1)) + y_t(end));
    
    % Calculamos el error relativo del Trapecio
    err_trap = abs(valor_exacto - I_trap) / valor_exacto * 100;
    
    % --- 2. Cálculo con la Regla de Simpson 1/3 ---
    % Verificamos que 'n' sea par antes de aplicar el método
    if mod(n, 2) == 0
        h_s = (b - a) / n;
        t_s = linspace(a, b, n + 1);
        y_s = B_prime(t_s);
        I_simp = (h_s / 3) * (y_s(1) + 4 * sum(y_s(2:2:end-1)) + 2 * sum(y_s(3:2:end-2)) + y_s(end));
        
        % Damos formato de texto a Simpson y a su error para imprimirlos
        simp_str = sprintf('%.6f', I_simp);
        err_simp = abs(valor_exacto - I_simp) / valor_exacto * 100;
        err_simp_str = sprintf('%.4f', err_simp);
    else
        % Si n es impar, indicamos que no se aplica y no hay error
        simp_str = 'No se aplica';
        err_simp_str = '-';
    end
    
    % --- 3. Imprimimos la fila completa con todos los datos ---
    fprintf('%-4d | %-12.6f | %-14.4f | %-14s | %-14s\n', n, I_trap, err_trap, simp_str, err_simp_str);
end

% --- Cálculo de la población final ---
B20 = B0 + valor_exacto;
fprintf('\nLa población estimada en t=20h es: %.6f bacterias\n', B20);