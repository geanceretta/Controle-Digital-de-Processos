close all; clear; clc;

% Amplitude de P(s) = 180V
A_p = 180;
% Período de P(s) = 20ms
T_p = 20e-3;

% Amplitude PWM = 250V
A_pwm = 250;
% Frequência de Amostragem de 10KHz
F_pwm = 10e3;
% Período de amostragem = 100us
T_pwm = 1/F_pwm;

% Numero de comparações por ciclo do PWM
NA=100;

% Frequência de comparação do PWM de 1MHz
Fs = F_pwm*NA;
% Período de amostragem = 1us
Ts = 1/Fs;

% Tempo total de simulação: 120ms
TT = 120e-3;
% 120ms/1us: 120000 pontos
NT = TT/Ts;

% Offset do ADC: 0,25V equivalem a -180V, 2,25V equivalem a +180V.
ADC_offset = 0.25;

st_counter = 0;
A_st = 2.5;
st_step = A_st/NA;

% Vetor de tempo
t = 0:Ts:TT;
% Contador de pontos da referência
v_ref_counter = 0;

% Inicialização dos vetores
v_ref=zeros(1, NT+1);
pwm=zeros(1, NT+1);

%Simulação
for n=1:NT+1

    % Gerando o sinal de referência
    v_ref(n) = v_ref_generator(v_ref_counter, A_p, Ts);
    v_ref_counter = v_ref_counter + 1;
    if v_ref_counter >= 0.020/Ts
        v_ref_counter = 0;
    end

    % Gerando o PWM
    st_step = A_st/NA;
    reference = (A_st/2) + ((A_st/2/200) * v_ref(n));
    pwm(n) = A_pwm * pwm_generator(v_ref(n), st_counter, st_step);
    st_counter = st_counter + 1;
    if st_counter > NA
        st_counter = 0;
    end

end

%% Geração dos gráficos
% subplot(211);
% plot(t, v_ref);
% title('Referência')
% subplot(212);
plot(t, pwm);
title('PWM')

function [v_ref_point] = v_ref_generator(v_ref_counter, amplitude, period)
    if v_ref_counter < 0.002/period % rampa zero à máxima
        v_ref_point = amplitude/(0.002/period)*v_ref_counter;
    elseif v_ref_counter < 0.008/period % tensão máxima
        v_ref_point = amplitude;
    elseif v_ref_counter < 0.010/period % rampa máximo a zero
        v_ref_point = amplitude - amplitude/(0.002/period)*(v_ref_counter - 0.008/period);
    elseif v_ref_counter < 0.012/period % rampa zero a mínima
        v_ref_point = 0 - amplitude/(0.002/period)*(v_ref_counter - 0.010/period);
    elseif v_ref_counter < 0.018/period % tensão mínima
         v_ref_point = -amplitude;
    elseif v_ref_counter < 0.020/period % rampa mínima a zero
         v_ref_point = -amplitude + amplitude/(0.002/period)*(v_ref_counter - 0.018/period);
    end
end

function [pwm_state] = pwm_generator(reference, counter, step)
    pwm_state = 0;
   st = counter * step;
   if reference >= st
       pwm_state = 1;
   end
end
