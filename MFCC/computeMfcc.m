%-------------------Computation of MFCC using MATLAB----------------------%
clear all;

[speech,Fs] = wavread('F:\Books And Documents\Projects\Speech Recognition\Speech Data Set\on_data_set_8k_5');

%%
%---Constants for speech signal processing

dim = size(speech');    %dimension of input speech signal
frame_size = 256;   %size of frame to be operated on
k = 1:frame_size;   %discrete frequency variable
zero_pad = (floor(dim(2)/frame_size))+1;    
total_frames = zero_pad*2; %frame overlapping is 50%
speech = padarray(speech')
speech = [speech' zeros(1,frame_size*zero_pad-dim(2))];    %zero-padding speech to multiple of frame_size

%%
%---Constants for the mel-scale
bank_num = 26;      %no of filter banks
low_mel = 20.50;    %lowest mel-scale frequency 30 Hz
high_mel = 2835;    %highest mel-scale frequency 8000 Hz
mel_freq = low_mel:(high_mel-low_mel)/bank_num:high_mel;   %centre freuqencies for mel-filterbanks in mel-scale
analog_freq = 700*(exp(mel_freq/1125)-1);      %centre frequencies for mel-scale in analog
digital_freq = floor(analog_freq/Fs*frame_size);    %centre frequencies for mel-scale in digital

%%
%---Calculation of Mel Filterbanks
for m = 2:bank_num
    for freq = 1:frame_size
        if(freq < digital_freq(m-1))
            melFilterBank(m-1,freq) = 0;
        elseif(freq >= digital_freq(m-1) && freq <= digital_freq(m))
            melFilterBank(m-1,freq) = (freq-digital_freq(m-1))/(digital_freq(m)-digital_freq(m-1));
        elseif(freq >= digital_freq(m) && freq <= digital_freq(m+1))
            melFilterBank(m-1,freq) = (digital_freq(m+1)-freq)/(digital_freq(m+1)-digital_freq(m));
        else
            melFilterBank(m-1,freq) = 0;
        end;
    end;
end;

%%
%---Periodogram and FFT of the signal
for frame = 0:total_frames-2
    extractedSpeech = speech(1,frame*frame_size/2+1:frame*frame_size/2+frame_size).*hamming(frame_size)'; %frame_size is divided by 2 due to frame overlap
    psdSpeech = fft(extractedSpeech);
    periodogram(frame+1,:) = abs(psdSpeech).^2/frame_size;
end;

%%
%---Calculation of Mel-Frequency Cepstral Coefficients

channelMat = sum((melFilterBank*periodogram'),2);
logChannelMat = log(channelMat);
staticCoe = dct(logChannelMat);

% staticDeltas = dct(log(sum((melFilterBank*periodogram'),2)));

%%
%---Calculation of MFCC deltas

interMat = [0 0 staticCoe' 0 0];
deltaKernel = [-2 -1 0 1 2];

for sift = 3:size(staticCoe)+2
    dynamicCoe(sift-2) = sum(interMat(1,sift-2:sift+2).*deltaKernel)/6;
end;

melCepstralCoe = [staticCoe' dynamicCoe];