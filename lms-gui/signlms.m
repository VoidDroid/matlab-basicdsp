function [filtSig, w, e] = signlms(x,d,M,mu)
% M = is the order of the filter
% sig = input signal
% d = desired output

%% ensure inputs are row vectors
x = x(:);
d = d(:);

%% define parameters of the LMS algorithm
N = length(x);
w = zeros(M,1);
e = zeros(N,1);
filtSig = zeros(N-M+1,1);

%% perform online weight update
for n = 1:N-M+1
    y = conj(w')*x(n:n+M-1);
    filtSig(n) = y;
    e(n) = d(n) - y;
    w = w + mu*x(n:n+M-1)*sign(conj(e(n)));
end;

e = e(1:end-M);
