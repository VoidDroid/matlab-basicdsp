%CONVOLUTION

function y = linconv(x,h)

	xstart = input('Enter index of value input which corresponds to n = 0: ');
	hstart = input('Enter index of value which corresponds to n = 0: ');

	l1 = length(x);
	l2 = length(h);

	y = zeros(1,l1+l2-1);

	%evaluating convolution
	for n = 0:1:l1+l2-1
		for k = 0:1:l1-1
			if((n-k>=0) && (n-k<=l2-1))  %since index <= length of function
			y(n+1) = y(n+1) + x(k+1).*h(n-k+1);
			end;
		end;
	end;

	%plotting the graphs
	subplot(3,1,1);
	stem((0:l1-1)-xstart,x);     %plots input
	axis([-l1-1 l1+1 min(x)-1 max(x)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Input');

	subplot(3,1,2);
	stem((0:l2-1)-hstart,h);     %plots unit-immpulse response
	axis([-l2-1 l2+1 min(h)-1 max(h)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Unit-Impulse Response');

	subplot(3,1,3);
	stem((0:l1+l2-2)-(xstart+hstart),y);        %plots output
	axis([-l1-l2-1 l1+l2+1 min(y)-1 max(y)+1]);
	xlabel('n');
	ylabel('x[n]');
	title('Output');
	
end