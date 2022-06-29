close all; clear all; clc;

% RESPOSTA AO IMPULSO

A_h = 0.8;                        % Amplitude h[n] = 0.8V
A_cc = 200;                       % Amplitude fonte CC = 200V
A_st_vpp = 2                    % Amplitude Vpp do dente de serra

To_h = 0.01;                      % Período da função h[n]=10ms
To_st = 0.001;                    % Período do sinal de serra
To_pwm = To_st;                     % Período do PWM = 1ms

Ts = To_st/100;                 % Período de amostragem 100x menor = 10us
NC_h = 6                          % Número de cíclos h[n] amostrados

f_h = 1/To_h;                       % Frequência h[n] = 100Hz
f_st = 1/To_st;                 % Frequência Dente de serra = 1KHz
f_pwm = f_st;                   % Frequência PWM = 1KHz


f_c = 10;                        % Frequência da portadora = 10Hz
A_c = 0.8;                      % Amplitude da portadora senoidal

NA = To_st/Ts;                   % Numero de amostras por ciclo PWM: 100
NC_st = (To_h/To_st) * NC_h;     % Numero de ciclos dente de serra contidos em 6 ciclos de h[n] = 60
NT = NC_st*NA;                   % 6 ciclos de h[n] ou 60 ciclos de dente de serra: 6000 pontos
TT = NT*Ts;                      % Tempo total do gráfico: 6000*10us = 60ms

t = 0:Ts:TT;                    % Vetor de tempo
nq = 0;                          % ?

% Inicialização dos vetores
h=zeros(1, NT+1);
x=zeros(1, NT+1);
y=zeros(1, NT+1);

%Simulação
for n=1:NT+1
  h(n) = A_h.*sin(2*pi.*f_h.*(Ts*n)).*e.^(-100*(Ts*n));
end

%% Geração dos gráficos
stem(t, h);



%z = e.^(-100*t);             % Taxa de decaímento
%h = A.*sin(2*pi.*f.*t).*z; % Resposta ao impulso
%stem(h);

% PWM
##A_ref = A;                           % Amplitude igual a da resposta ao impulso
##f_ref = 10;                          % Frequência do sinal de referência = 10Hz
##T_ref = 1/f_ref;                     % Período do sinal de referência = 100ms
##sr_ref = T_ref/100;                  % Período de amostragem 100x menor
##t_ref = 0:sr_ref:6*T_ref;             % Intervalo de amostragem contendo 6 períodos
##
##v_ref_t = A_ref*sin(2*pi*f_ref*t_ref);   % Sinal de referência
%stem(v_ref_t)

% DENTE DE SERRA
% pkg install -forge control
% pkg install -forge signal
%pkg load signal

%T_st = 0.001;                          % Período do sinal dente de serra
%dente_serra = sawtooth(2*pi*f*t);
%plot(t, dente_serra);

%for i = 1:numel(t_ref):

%% Resposta ao Impulso (h[n]
%subplot(311)
%stem(t,h,'r:','Linewidth',2);
%subplot(312)
%stem(t,x,'b:','Linewidth',2);
%subplot(313)
%stem(t,y,'b:','Linewidth',2);

