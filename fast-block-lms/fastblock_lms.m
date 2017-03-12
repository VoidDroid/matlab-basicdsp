% Author - DeepC
%
% Current Version - 1.0
%
% FASTBLOCK_LMS: Performs fast-block LMS filtering on input signals
% 
% Fast-block LMS provides a computationally efficient implementation of LMS
% filtering for sequences of long duration. It relies on two basic blocks - 
% the Fast-Fourier Transform (FFT) and the Over-save Method.
% 
% INPUTS:
% 
% x - input sequence
% d - desired response
% M - filter taps
% lr - learning rate
% weight_scale - variance of the initial weight values
% 
% OUTPUTS:
% 
% y - filtered signal
% w_opt - optimum weight values

function [y, w_opt] = fastblock_lms(x, d, M, lr, weight_scale)

    % ensure inputs are row vectors
    x = x(:);
    d = d(:);

    % define input parameters & initialise weights
    seq_len = length(x);
    w = randn(M,1)*weight_scale;
    w_cap = padarray(w, [M,0], 'post');
    y = zeros(seq_len,1);

    % compute fft of weights
    fft_w_cap = fft(w_cap);

    % make sequence length a multiple of M
    if(mod(seq_len, M) ~= 0)
        seq_len = padarray(seq_len, [mod(seq_len,M),0], 'post');
    end;
    numblocks = seq_len / M;

    for k = 2:numblocks-1
        % create a diagonal matrix with two consecutive blocks
        % of x_k on main diagonal
        u_k = fft([x(M*(k-1)+1:M*k); x(M*k+1:M*(k+1))]);
        u_k = diag(u_k);

        % compute predicted response using overlap-save method
        % only the last M elements of y_k are retained
        y_k = ifft(u_k * fft_w_cap);
        y_k = y_k(M+1:end);
        y(M*(k-1)+1:M*k) = real(y_k);

        % compute error signal of block k
        e_k = d(M*k+1:M*(k+1)) - y_k;
        e_k = padarray(e_k, [M,0], 'pre');
        fft_e_k = fft(e_k);

        % compute the derivative of loss and retain the
        % first M elements
        phi_k = ifft(u_k'*e_k);
        phi_k = padarray(phi_k(1:M), [M,0], 'post');

        % update weight vector using LMS
        fft_w_cap = fft_w_cap + lr*fft(phi_k);
    end;
   
    w_opt = ifft(fft_w_cap);
    w_opt = w_opt(1:M);
end