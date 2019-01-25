%% MFCC on MATLAB

clearvars

[speech,Fs] = wavread('\Speech Recognition\Speech Data Set\on_data_set_8k_5');

%% Constants for speech signal processing

speech = speech';
LENGTH_SPEECH = length(speech);    %dimension of input speech signal
FRAME_SIZE = 256;   % frame size for speech\
OVERLAP_PARAMETER = 2; % 1 = no overlap, 2 = 50%, 4 = 75% etc.
speech = padarray(speech, ceil(length(speech)/FRAME_SIZE)*FRAME_SIZE - LENGTH_SPEECH, 'post'); % zero-pad to a multiple of frame_size
TOTAL_FRAMES = length(speech) / FRAME_SIZE * OVERLAP_PARAMETER;
k = 1:FRAME_SIZE; % digital frequencies of signal

%% Constants for the mel-scale

NUM_FILTER_BANKS = 26;      %no of filter banks
MEL_LOW = 20.50;    %lowest mel-scale frequency 30 Hz
MEL_HIGH = 2835;    %highest mel-scale frequency 8000 Hz
DELTA = (MEL_HIGH-MEL_LOW)/NUM_FILTER_BANKS;
mel_freq = MEL_LOW:DELTA:MEL_HIGH;   % centre freuqencies for mel-filterbanks in mel-scale
centre_analog_freq = 700*(exp(mel_freq/1125)-1);      % centre frequencies for mel-scale in analog
centre_digital_freq = ceil(centre_analog_freq/Fs*FRAME_SIZE);    % centre frequencies for mel-scale in digital

%% Calculation of Mel Filterbanks

for m = 2:NUM_FILTER_BANKS
    
    idx_rise = find(k >= centre_digital_freq(m-1) & k <= centre_digital_freq(m));
    idx_fall = find(k > centre_digital_freq(m) & k <= centre_digital_freq(m+1));
    melFilterBank{m} = [zeros(1,centre_digital_freq(m-1)),...
    (k(idx_rise)-centre_digital_freq(m-1)) / (centre_digital_freq(m)-centre_digital_freq(m-1)),...
    (centre_digital_freq(m+1)-k(idx_fall))/(centre_digital_freq(m+1)-centre_digital_freq(m)),...
    zeros(1,centre_digital_freq(end)-centre_digital_freq(m+1))];
%     for freq = 1:frame_size
%         if(freq < centre_digital_freq(m-1))
%             melFilterBank(m-1,freq) = 0;
%         elseif(freq >= centre_digital_freq(m-1) && freq <= centre_digital_freq(m))
%             melFilterBank(m-1,freq) = (freq-centre_digital_freq(m-1))/(centre_digital_freq(m)-centre_digital_freq(m-1));
%         elseif(freq >= centre_digital_freq(m) && freq <= centre_digital_freq(m+1))
%             melFilterBank(m-1,freq) = (centre_digital_freq(m+1)-freq)/(centre_digital_freq(m+1)-centre_digital_freq(m));
%         else
%             melFilterBank(m-1,freq) = 0;
%         end;
%     end;
end

%%
%---Periodogram and FFT of the signal
for frame = 0:TOTAL_FRAMES-2
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