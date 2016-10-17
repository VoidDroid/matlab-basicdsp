%RECURSIVE SINE AND COSINE GENERATOR

function [s,c] = recursin(F,Fs,N,R)

	f0 = F/Fs;
	m = 0:N-1;

	% define constants
	A = cos(2*pi*f0);
	B = sin(2*pi*f0);

	% initial values of sine and cosine
	s(1) = 0;
	c(1) = 1;

	for n = 1:N-1
		s(n+1) = A*s(n)+B*c(n);
		c(n+1) = A*c(n)-B*s(n);
	end;

	% plot the graphs
	subplot(2,2,1);
	plot(m,R*s);    %plots recursive sine
	xlabel('time');
	ylabel('sine');
	title('Recursive sine');

	subplot(2,2,2);
	plot(m,R*c);    %plots recursive cosine
	xlabel('time');
	ylabel('cosine');
	title('Recursive cosine');

	% plot fourier transform
	dfts = fft(s);
	dftc = fft(c);

	k = 0:N-1;
	Fk = Fs*(k/N);

	subplot(2,2,3);
	plot(Fk,abs(dfts));  % plots DFT of sine
	xlabel('frequency');
	ylabel('sine');
	title('FT of sine');

	subplot(2,2,4);
	plot(Fk,abs(dftc));  % plots DFT of cosine
	xlabel('frequency');
	ylabel('sine');
	title('FT of cosine');
	
end