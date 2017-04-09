% Author - Deepankar C
%
% Current Version - 1.0
% 
% Fast-block LMS provides a computationally efficient implementation of LMS
% filtering for sequences of long duration. It relies on two basic blocks - 
% the Fast-Fourier Transform (FFT) and the Overlap-Save Method.
%

function [y, w_opt] = fastblock_lms(x, d, M, lr, gamma)
% FASTBLOCK_LMS: Performs fast-block LMS filtering on input signals
% 
% INPUTS:
% x - input sequence
% d - desired response
% M - filter taps
% lr - learning rate/step-size
% gamma - forgetting factor; default = 0.99
% 
% OUTPUTS:
% y - filtered output signal
% w_opt - optimum weight values
% 
% USAGE:
% [y, w_opt] = fastblock_lms(x, d, M, lr, gamma)

    if(nargin < 4)
        error('Not enough input arguments. USAGE: [y, optimal_weights] = fastblock_lms(x, desired_signal, taps, step-size, gamma)');
    elseif(nargin == 4)
        gamma = 0.99;
    end; 

    % ensure inputs are col vectors
    x = x(:);
    d = d(:);

    % define input parameters & initialise weights
    x = padarray(x, [M,0], 'pre');
    seq_len = length(x);
    w = zeros(M,1);
    w_cap = padarray(w, [M,0], 'post');
    p_k = ones(2*M,1);

    % compute fft of weights
    fft_w_cap = fft(w_cap, 2*M);

    % make sequence length a multiple of M
    if(mod(seq_len, M) ~= 0)
        x = padarray(x, [mod(seq_len,M),0], 'post');
        seq_len = seq_len + mod(seq_len,M);
    end;
    y = zeros(seq_len,1);
    numblocks = seq_len / M;

    for k = 1:numblocks-1
        % create a diagonal matrix with two consecutive blocks
        % of x_k on main diagonal
        u_k = fft([x(M*(k-1)+1:M*k); x(M*k+1:M*(k+1))], 2*M);
        u_k = diag(u_k);

        % compute predicted response using overlap-save method
        % only the last M elements of y_k are retained
        y_k = ifft(u_k * fft_w_cap, 2*M);
        y_k = y_k(M+1:end);
        y(M*(k-1)+1:M*k) = real(y_k);

        % compute error signal of block k
        e_k = d(M*(k-1)+1:M*k) - y_k;
        e_k = padarray(e_k, [M,0], 'pre');
        fft_e_k = fft(e_k, 2*M);
        
        % compute signal power matrix for adaptively annealing
        % the learning rate; used in non-stationary environments
        p_k = gamma * p_k + (1-gamma) * diag(u_k' * u_k);
        inv_p_k = diag(1 ./ p_k);

        % compute the derivative of loss and retain the
        % first M elements
        phi_k = ifft(inv_p_k * u_k' * fft_e_k, 2*M);
        phi_k = padarray(phi_k(1:M), [M,0], 'post');

        % update weight vector using LMS
        fft_w_cap = fft_w_cap + lr*fft(phi_k, 2*M);
    end;
   
    w_opt = ifft(fft_w_cap, 2*M);
    w_opt = real(w_opt(1:M));
    y = y(M+1:end);
end