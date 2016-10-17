%CIRCULAR CONVOLUTION USING MATRIX METHOD

function y = cirmatmethodconv(x,h)

	xstart = input('Enter index of value input which corresponds to n = 0: ');
	hstart = input('Enter index of value which corresponds to n = 0: ');

	l1 = length(x);
	l2 = length(h);
	maxLength = max(l1,l2);
	hMat = zeros([maxLength]);

	if(l1 <= l2)
		x = [x zeros(1,l2-l1)];
	else
		h = [h zeros(1,l1-l2)];
	end;

	for n = 0:maxLength-1
		for k = 0:maxLength-1
			hMat(k+1,n+1) = h(mod(k-n,maxLength)+1);
		end;
	end;

	y = hMat*transpose(x);

	%plotting the graphs
	subplot(3,1,1);
	stem((0:maxLength-1)-xstart,x);     %plots input
	axis([-l1-1 l1+1 min(x)-1 max(x)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Input');

	subplot(3,1,2);
	stem((0:maxLength-1)-hstart,h);     %plots unit-impulse response
	axis([-l2-1 l2+1 min(h)-1 max(h)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Unit-Impulse Response');

	subplot(3,1,3);
	stem((0:maxLength-1)-(xstart+hstart),y);        %plots output
	axis([-l1-l2-1 l1+l2+1 min(y)-1 max(y)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Output');

end