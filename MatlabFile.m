%clearing and closing
clc
close all
warning off
fs=8000; %Fs is Sampling frequency in Hertz
ch=1; %mono audio
datatype='uint8';
nbits=16;
Nsecs=5;
%to record audio from external device user recorder function
recorder=audiorecorder(fs,nbits,ch);
disp('Start Speaking (max duration 5 seconds)');
%to stop the recording use recordblocking function
recordblocking(recorder,Nsecs);
disp('Recorded.');
%storing audio in numeric array use getaudiodata function
x=getaudiodata(recorder,datatype);
%to write the audio file
audiowrite('test.wav',x,fs);
%reading the audio file
filename = 'test.wav';
[x,fs] = audioread(filename);
% Take the FFT of the audio signal to get fm
X = fft(x);
mag_X = abs(X);
freq_axis = linspace(0, fs/2, length(mag_X)/2);
[~, max_index] = max(mag_X(1:length(mag_X)/2));
max_freq = freq_axis(max_index);
omega = max_freq * 2 * pi;
fm = omega / 2;
%display
disp(['The modulating frequency of the audio is: ', num2str(fm), 'Hz']);

%defining quantization levels
nQBits = 8;
nLevels = 2^nQBits;
% Compute Quantization step size
maxVal = max(abs(x));
stepSize = maxVal / (nLevels -1);
%Quantize Signals
x_quantized = quantiz(x, linspace(-maxVal, maxVal, nLevels-1));
%converting quantized signal to 8 bit binary stream
nBBits = 8;
x_quantized_norm = (x_quantized - min(x_quantized)) / (max(x_quantized) - min(x_quantized));
x_binary = de2bi(round(x_quantized_norm * (2^nBBits-1)), nBBits, 'left-msb');
x_binary_stream = x_binary(:)';
%Displaying binary stream
disp('Binary Stream: ');
disp(num2str(x_binary_stream));
