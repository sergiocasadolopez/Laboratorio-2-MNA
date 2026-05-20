function laboratorio2()
    
    clear; clc;
    
    % --- Parámetros iniciales ---
    a = 0;             % Tiempo inicial (horas)
    b = 20;            % Tiempo final (horas)
    B0 = 25;           % Población inicial
    
    % Función anónima para B'(t)
    B_prime = @(t) (30 * exp(-0.1 * t)) ./ (1 + 3 * exp(-0.1 * t)).^2;
    
    % Valor analítico exacto (obtenido por integración por sustitución)
    F_analitica = @(t) 100 ./ (1 + 3 * exp(-0.1 * t));
    valor_exacto = F_analitica(b) - F_analitica(a);
    
    % =====================================================================
    % PARTE 1: Estudio para n = 2 subintervalos
    % =====================================================================
    n2 = 2;
    trap2 = regla_trapecio(B_prime, a, b, n2);
    simp2 = regla_simpson(B_prime, a, b, n2);
    
    fprintf('=====================================================\n');
    fprintf('           RESULTADOS PARA N = 2 SUBINTERVALOS        \n');
    fprintf('=====================================================\n');
    fprintf('Valor Exacto Analítico : %.6f\n', valor_exacto);
    fprintf('Aproximación Trapecio  : %.6f (Error Rel: %.4f%%)\n', trap2, calcular_error(valor_exacto, trap2));
    fprintf('Aproximación Simpson   : %.6f (Error Rel: %.4f%%)\n\n', simp2, calcular_error(valor_exacto, simp2));
    
    % =====================================================================
    % PARTE 2: Estudio comparativo desde n = 3 hasta n = 10
    % =====================================================================
    fprintf('=====================================================================\n');
    fprintf('      TABLA COMPARATIVA DE CONVERGENCIA (n = 3 hasta n = 10)       \n');
    fprintf('=====================================================================\n');
    fprintf('%-4s | %-14s | %-12s | %-14s | %-12s\n', 'n', 'Trapecio', 'Err Trap', 'Simpson 1/3', 'Err Simp');
    fprintf('%s\n', repmat('-', 1, 68));
    
    for n = 3:10
        % Cálculo por Trapecio
        t_res = regla_trapecio(B_prime, a, b, n);
        err_t = sprintf('%.4f%%', calcular_error(valor_exacto, t_res));
        
        % Cálculo por Simpson (Validando restricción de paridad)
        if mod(n, 2) == 0
            s_res = regla_simpson(B_prime, a, b, n);
            s_str = sprintf('%.6f', s_res);
            err_s = sprintf('%.4f%%', calcular_error(valor_exacto, s_res));
        else
            s_str = 'No aplicable';
            err_s = '-';
        end
        
        fprintf('%-4d | %-14.6f | %-12s | %-14s | %-12s\n', n, t_res, err_t, s_str, err_s);
    end
    
    % =====================================================================
    % PARTE 3: Tamaño de la población final
    % =====================================================================
    B20 = B0 + valor_exacto;
    fprintf('\n=====================================================\n');
    fprintf('                POBLACIÓN FINAL ESTIMADA             \n');
    fprintf('=====================================================\n');
    fprintf('Población al cabo de 20 horas (B(20)): %.6f bacterias\n', B20);
    fprintf('=====================================================\n');
end

% --- Subfunción: Regla del Trapecio Compuesta ---
function I = regla_trapecio(f, a, b, n)
    h = (b - a) / n;
    t = linspace(a, b, n + 1);
    y = f(t);
    I = (h / 2) * (y(1) + 2 * sum(y(2:end-1)) + y(end));
end

% --- Subfunción: Regla de Simpson 1/3 Compuesta ---
function I = regla_simpson(f, a, b, n)
    h = (b - a) / n;
    t = linspace(a, b, n + 1);
    y = f(t);
    % En MATLAB el índice 1 es t0, el índice 2 es t1, etc.
    % Nodos impares matemáticos (t1, t3...) -> Índices pares en MATLAB
    % Nodos pares matemáticos (t2, t4...) -> Índices impares en MATLAB
    I = (h / 3) * (y(1) + 4 * sum(y(2:2:end-1)) + 2 * sum(y(3:2:end-2)) + y(end));
end

% --- Subfunción: Cálculo del Error Relativo Porcentual ---
function err = calcular_error(exacto, aproximado)
    err = (abs(exacto - aproximado) / exacto) * 100;
end