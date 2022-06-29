close all; clear all; clc;

% RESPOSTA AO IMPULSO

A_h = 0.8;                        % Amplitude h[n] = 0.8V
A_cc = 200;                       % Amplitude fonte CC = 200V
A_st_vpp = 2;                    % Amplitude Vpp do dente de serra

To_h = 0.01;                      % Período da função h[n]=10ms
To_st = 0.001;                    % Período do sinal de serra
To_pwm = To_st;                     % Período do PWM = 1ms

Ts = To_st/100;                 % Período de amostragem 100x menor = 10us
NC_h = 6;                          % Número de cíclos h[n] amostrados

f_h = 1/To_h;                       % Frequência h[n] = 100Hz
f_st = 1/To_st;                 % Frequência Dente de serra = 1KHz
f_pwm = f_st;                   % Frequência PWM = 1KHz


f_s = 10;                        % Frequência da portadora = 10Hz
A_s = 0.8;                      % Amplitude da portadora senoidal

NA = To_st/Ts;                   % Numero de amostras por ciclo PWM: 100
NC_st = (To_h/To_st) * NC_h;     % Numero de ciclos dente de serra contidos em 6 ciclos de h[n] = 60
NT = NC_st*NA;                   % 6 ciclos de h[n] ou 60 ciclos de dente de serra: 6000 pontos
TT = NT*Ts;                      % Tempo total do gráfico: 6000*10us = 60ms

t = 0:Ts:TT;                    % Vetor de tempo
nq = 0;                          % ?
D = 0;                           % PWM Duty Cycle

% Inicialização dos vetores
h=zeros(1, NT+1);
s=zeros(1, NT+1);
st=zeros(1, NT+1);
x=zeros(1, NT+1);
y=zeros(1, NT+1);

%Simulação
for n=1:NT+1
  h(n) = A_h.*sin(2*pi.*f_h.*(Ts*n)).*e.^(-100*(Ts*n));
  s(n) = A_s.*sin(2*pi.*f_s.*(Ts*n));
  % Geração do PWM:
  nq = nq+1;
  if nq>NA
    st(n) = 0;
  endif
  if nq == NA
    nq = 0;
  endif
  st(n) = nq*(A_st_vpp/100)-(A_st_vpp/2);
  if s(n) > st(n)
    pwm(n) = A_cc;
  else
    pwm(n) = 0;
  endif
end

%% Geração dos gráficos
subplot(411)
stem(t, h);
subplot(412)
stem(t, s);
subplot(413)
plot(t, st);
subplot(414)
stem(t, pwm);
