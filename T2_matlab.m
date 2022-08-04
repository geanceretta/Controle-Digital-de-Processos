close all; clear; clc;

A_p = 180;                         % Amplitude de P(s) = 180V
T_p = 20e-3;                       % Período de P(s) = 20ms

Fs = 10e3;                      % Frequência de Amostragem de 10KHz
Ts = 1/Fs;                      % Período de amostragem = 100us

TT = 120e-3;                      % Tempo total de simulação: 120ms
NT = TT/Ts;                       % 120ms/100us: 1200 pontos


t = 0:Ts:TT;                    % Vetor de tempo
nq = 0;                          % Contador de pontos da referência

% Inicialização dos vetores
v_ref=zeros(1, NT+1);

%Simulação
for n=1:NT+1
    if nq < 0.002/Ts % rampa zero à máxima
        v_ref(n) = A_p/(0.002/Ts)*nq;
    elseif nq < 0.008/Ts % tensão máxima
        v_ref(n) = A_p;
    elseif nq < 0.010/Ts % rampa máximo a zero
        v_ref(n) = A_p - A_p/(0.002/Ts)*(nq - 0.008/Ts);
    elseif nq < 0.012/Ts % rampa zero a mínima
        v_ref(n) = 0 - A_p/(0.002/Ts)*(nq - 0.010/Ts);
    elseif nq < 0.018/Ts % tensão mínima
         v_ref(n) = -A_p;
    elseif nq < 0.020/Ts % rampa mínima a zero
         v_ref(n) = -A_p + A_p/(0.002/Ts)*(nq - 0.018/Ts);
    else
        nq = 0;
    end
    nq = nq+1;
end

%% Geração dos gráficos
plot(t, v_ref);
title('Referência')

