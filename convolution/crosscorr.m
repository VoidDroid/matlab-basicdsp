%AUTO AND CROSS CORRELATION

function corrMat = crosscorr(x,h)

	X_START = input('Enter index of value input which corresponds to n = 0: ');
	Y_START = input('Enter index of value which corresponds to n = 0: ');

	yFlip = fliplr(y);

	l1 = length(x);
	l2 = length(y);

	corrMat = zeros(1,l1+l2-1);

	%evaluating convolution
	for n = 0:1:l1+l2-1
		for k = 0:1:l1-1
			if((n-k>=0) && (n-k<=l2-1))  %since index <= length of function
			corrMat(n+1) = corrMat(n+1) + x(k+1)*yFlip(n-k+1);
			end;
		end;
	end;

	%plotting the graphs
	subplot(3,1,1);
	stem((0:l1-1)-X_START,x);     %plots signal 
	axis([-l1-1 l1+1 min(x)-1 max(x)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Signal 1');

	subplot(3,1,2);
	stem((0:l2-1)-Y_START,y);     %plots signal 2
	axis([-l2-1 l2+1 min(y)-1 max(y)+1]);
	xlabel('n');
	ylabel('y[n]');
	title('Signal 2');

	subplot(3,1,3);
	stem((0:l1+l2-2)-(X_START+Y_START)-l1+1,corrMat);        %plots correlation matrix
	axis([-l1-l2-1 l1+l2+1 min(corrMat)-1 max(corrMat)+1]);
	xlabel('n');
	ylabel('corrMat[n]');
	title('Correlation Coefficients');
	
end