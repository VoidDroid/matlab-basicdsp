function varargout = lms_var(varargin)
% GUI Tool for LMS algorithms version 0.5
% Author: Deepankar Chanda

% LMS_VAR MATLAB code for lms_var.fig
%      LMS_VAR, by itself, creates a new LMS_VAR or raises the existing
%      singleton*.
%
%      H = LMS_VAR returns the handle to a new LMS_VAR or the handle to
%      the existing singleton*.
%
%      LMS_VAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LMS_VAR.M with the given input arguments.
%
%      LMS_VAR('Property','Value',...) creates a new LMS_VAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lms_var_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lms_var_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 21-Nov-2016 16:44:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lms_var_OpeningFcn, ...
                   'gui_OutputFcn',  @lms_var_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before lms_var is made visible.
function lms_var_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lms_var (see VARARGIN)

% disable/enable initialisation for buttons/fields
set(handles.arb_wave, 'Enable','off');
set(handles.load_arb_wave, 'Enable','off');
set(handles.noise_lambda, 'Enable','off');
set(handles.ok_noise_lambda, 'Enable','off');

global lmsAxesStatus;
lmsAxesStatus = 0;

global fontSize;
fontSize = 8; % for axis

% waveform axes
axes(handles.axes_waveform);
title('Waveform','FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Amplitude', 'FontSize', fontSize);

% noise axes
axes(handles.axes_noise);
title('Noise','FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Amplitude', 'FontSize', fontSize);

% learning curve axes
axes(handles.axes_learn_curve);
title('Learning Curve','FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Weights', 'FontSize', fontSize);

% input signal axes
axes(handles.axes_signal);
title('Input Signal','FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Amplitude', 'FontSize', fontSize);

% filtered signal axes
axes(handles.axes_filt_signal);
title('Filtered Signal','FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Amplitude', 'FontSize', fontSize);

% Choose default command line output for lms_var
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lms_var wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lms_var_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% ==============================================WAVEFORM PARAMS==============================================

function wavfreq_Callback(hObject, eventdata, handles)
% hObject    handle to wavfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavfreq as text
%        str2double(get(hObject,'String')) returns contents of wavfreq as a double


% --- Executes during object creation, after setting all properties.
function wavfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok_freq.
function ok_freq_Callback(hObject, eventdata, handles)

    % get signal frequency
    freq = str2double(get(handles.wavfreq,'string'))*1000;
    global fontSize;
    
    if(isnan(freq))
        error('Input must be a number.');
    else
        assignin('base','freq',freq)
        
        % define sampling frequency
        Fs = 1e5;
        sampleTime = 0.1;
        n = 0:1/Fs:sampleTime-1/Fs;
        
        % set axis properties
        axes(handles.axes_waveform);
        zoom xon
        
        % plot waveform corresponding to selected option
        if(get(handles.rdob_sin,'Value') == 1)
            sinwave = sin(2*pi*freq*n);
            assignin('base','waveform',sinwave);
            plot(sinwave);
        elseif(get(handles.rdob_sq,'Value') == 1)
            sqwave = square(2*pi*freq*n);
            assignin('base','waveform',sqwave);
            plot(sqwave);       
        elseif(get(handles.rdob_tri,'Value') == 1)
            triwave = sawtooth(2*pi*freq*n,0.5);
            assignin('base','waveform',triwave);
            plot(triwave);
        end;
        
        axis(handles.axes_waveform,[0 Fs/10 -1.5 1.5]);
        title('Waveform','FontSize', fontSize);
        xlabel('Time', 'FontSize', fontSize);
        ylabel('Amplitude', 'FontSize', fontSize);
    end;


function arb_wave_Callback(hObject, eventdata, handles)
% hObject    handle to arb_wave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arb_wave as text
%        str2double(get(hObject,'String')) returns contents of arb_wave as a double


% --- Executes during object creation, after setting all properties.
function arb_wave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arb_wave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_arb_wave.
function load_arb_wave_Callback(hObject, eventdata, handles)
% hObject    handle to load_arb_wave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ===============================================**********===============================================



%% ==============================================NOISE PARAMS==============================================

% --- Executes on button press in ok_sigma_noise.
function ok_sigma_noise_Callback(hObject, eventdata, handles)
% hObject    handle to ok_sigma_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % set axis properties
    axes(handles.axes_noise);
    zoom xon
    global fontSize;
    global ip_sig;
    
    % get standard deviation
    sigma = str2double(get(handles.sigma_noise,'string'));
    
    
    % check if selected
%    if(get(handles.rdob_w,'Value') == 1)
        noise_sig = (-0.5 + rand(1,1e4)).*sigma;
        plot(noise_sig);
 %   end;

    axis(handles.axes_noise,[0 1e4 -1.5 1.5]);
    title('Noise','FontSize', fontSize);
    xlabel('Time', 'FontSize', fontSize);
    ylabel('Amplitude', 'FontSize', fontSize);
    
    % set axis properties
    axes(handles.axes_signal);
    zoom xon
    
    waveform = evalin('base','waveform');
    ip_sig = waveform + noise_sig;
    plot(ip_sig);
    axis(handles.axes_signal,[0 1e4 -1.5 1.5]);
    title('Input Signal','FontSize', fontSize);
    xlabel('Time', 'FontSize', fontSize);
    ylabel('Amplitude', 'FontSize', fontSize);
    

function sigma_noise_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma_noise as text
%        str2double(get(hObject,'String')) returns contents of sigma_noise as a double

% --- Executes during object creation, after setting all properties.
function sigma_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function noise_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to noise_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_lambda as text
%        str2double(get(hObject,'String')) returns contents of noise_lambda as a double

% --- Executes during object creation, after setting all properties.
function noise_lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ok_noise_lambda.
function ok_noise_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to ok_noise_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % set axis properties
    axes(handles.axes_noise);
    zoom xon
    global fontSize;
    global ip_sig;
    
    % check if selected
%   if(get(handles.rdob_w,'Value') == 1)
        lambda = str2double(get(handles.noise_lambda,'string'));
        noise_sig = -0.5 + poissrnd(lambda,1,1e4);
        plot(noise_sig);
%   end;

    axis(handles.axes_noise,[0 1e4 -1.5 1.5]);
    title('Noise','FontSize', fontSize);
    xlabel('Time', 'FontSize', fontSize);
    ylabel('Amplitude', 'FontSize', fontSize);
    
    % set axis properties
    axes(handles.axes_signal);
    zoom xon
    
    waveform = evalin('base','waveform');
    ip_sig = waveform + noise_sig;
    plot(ip_sig);
    axis(handles.axes_noise,[0 1e4 -1.5 1.5]);
    title('Input Signal','FontSize', fontSize);
    xlabel('Time', 'FontSize', fontSize);
    ylabel('Amplitude', 'FontSize', fontSize);
    

%% =================================================**********=================================================


%% ============================================LMS ALGORITHMS PARAMS===========================================

function step_size_Callback(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size as text
%        str2double(get(hObject,'String')) returns contents of step_size as a double

% --- Executes during object creation, after setting all properties.
function step_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ok_step.
function ok_step_Callback(hObject, eventdata, handles)
% hObject    handle to ok_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global step_size;
step_size = str2double(get(handles.step_size,'string'));


function order_val_Callback(hObject, eventdata, handles)
% hObject    handle to order_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of order_val as text
%        str2double(get(hObject,'String')) returns contents of order_val as a double

% --- Executes during object creation, after setting all properties.
function order_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to order_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ok_order.
function ok_order_Callback(hObject, eventdata, handles)
% hObject    handle to ok_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global order_lms;
order_lms = str2double(get(handles.order_val,'string'));

% --- Executes on button press in eval_lms.
function eval_lms_Callback(hObject, eventdata, handles)
% hObject    handle to eval_lms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lmsAlgoSel; global lmsAxesStatus;
global filtSig; global errlc; global ip_sig;
global step_size; global order_lms;

waveform = evalin('base','waveform');

switch(lmsAlgoSel)
    case 1
        [filtSig, ~, errlc] = lms(ip_sig,waveform,order_lms,step_size);
    case 2
        [filtSig, ~, errlc] = signlms(ip_sig,waveform,order_lms,step_size);
    case 3
        [filtSig, ~, errlc] = zflms(ip_sig,waveform,order_lms,step_size);
    case 4
        [filtSig, ~, errlc] = nlms(ip_sig,waveform,order_lms,step_size);
    case 5
        [filtSig, ~, errlc] = clippedlms(ip_sig,waveform,order_lms,step_size);
end;

lmsAxesStatus = 1;
axes_learn_curve_CreateFcn(hObject, eventdata, handles);
axes_filt_signal_CreateFcn(hObject, eventdata, handles);


%% ================================================**********================================================


%% ==============================================LMS ALGORITHMS==============================================


% --- Executes on button press in rdob_lms.
function rdob_lms_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_lms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lmsAlgoSel;
if(get(hObject,'Value') == 1)
    lmsAlgoSel = 1;
end;
% Hint: get(hObject,'Value') returns toggle state of rdob_lms


% --- Executes on button press in rdob_slms.
function rdob_slms_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_slms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lmsAlgoSel;
if(get(hObject,'Value') == 1)
    lmsAlgoSel = 2;
end;
% Hint: get(hObject,'Value') returns toggle state of rdob_slms


% --- Executes on button press in rdob_zflms.
function rdob_zflms_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_zflms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lmsAlgoSel;
if(get(hObject,'Value') == 1)
    lmsAlgoSel = 3;
end;
% Hint: get(hObject,'Value') returns toggle state of rdob_zflms


% --- Executes on button press in rdob_nlms.
function rdob_nlms_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_nlms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lmsAlgoSel;
if(get(hObject,'Value') == 1)
    lmsAlgoSel = 4;
end;
% Hint: get(hObject,'Value') returns toggle state of rdob_nlms


% --- Executes on button press in rdob_clms.
function rdob_clms_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_clms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lmsAlgoSel;
if(get(hObject,'Value') == 1)
    lmsAlgoSel = 5;
end;
% Hint: get(hObject,'Value') returns toggle state of rdob_clms

%% ==============================================**********==============================================


%% ============================================= WAVEFORMS ==============================================

% --- Executes on button press in rdob_sq.
function rdob_sq_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_sq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wavfreq, 'Enable','on');
set(handles.ok_freq, 'Enable','on');
set(handles.arb_wave, 'Enable','off');
set(handles.load_arb_wave, 'Enable','off');
% Hint: get(hObject,'Value') returns toggle state of rdob_sq


% --- Executes on button press in rdob_tri.
function rdob_tri_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_tri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wavfreq, 'Enable','on');
set(handles.ok_freq, 'Enable','on');
set(handles.arb_wave, 'Enable','off');
set(handles.load_arb_wave, 'Enable','off');
% Hint: get(hObject,'Value') returns toggle state of rdob_tri


% --- Executes on button press in rdob_sin.
function rdob_sin_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_sin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wavfreq, 'Enable','on');
set(handles.ok_freq, 'Enable','on');
set(handles.arb_wave, 'Enable','off');
set(handles.load_arb_wave, 'Enable','off');
% Hint: get(hObject,'Value') returns toggle state of rdob_sin


% --- Executes on button press in rdob_arb.
function rdob_arb_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_arb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wavfreq, 'Enable','off');
set(handles.ok_freq, 'Enable','off');
set(handles.arb_wave, 'Enable','on');
set(handles.load_arb_wave, 'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of rdob_arb
%% ==============================================**********==============================================


%% ==============================================  NOISE  ===============================================

% --- Executes on button press in rdob_w.
function rdob_w_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.noise_lambda, 'Enable','off');
    set(handles.ok_noise_lambda, 'Enable','off');
    set(handles.sigma_noise, 'Enable','on');
    set(handles.ok_sigma_noise, 'Enable','on');
    

% --- Executes on button press in rdob_p.
function rdob_p_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.noise_lambda, 'Enable','off');
    set(handles.ok_noise_lambda, 'Enable','off');
    set(handles.sigma_noise, 'Enable','off');
    set(handles.ok_sigma_noise, 'Enable','off');

    % set axis properties
    axes(handles.axes_noise);
    zoom xon
    global fontSize;
    global ip_sig;
    
    % get signal frequency
    freq = str2double(get(handles.wavfreq,'string'))*1000;
%    sigma = str2double(get(handles.sigma_noise,'string'));
    sigma = 0.5;
    alpha = 1.081;
    
    % check if selected
    % if(get(handles.rdob_w,'Value') == 1)
        noise_mag = fft(randn(1,1e4).*sigma).^2;
        noise_sig = ifft(noise_mag./freq^(alpha));
        plot(noise_sig);
    % end;

    axis(handles.axes_noise,[0 1e4 -1.5 1.5]);
    title('Noise','FontSize', fontSize);
    xlabel('Time', 'FontSize', fontSize);
    ylabel('Amplitude', 'FontSize', fontSize);
    
    % set axis properties
    axes(handles.axes_signal);
    zoom xon
    
    waveform = evalin('base','waveform');
    ip_sig = waveform + noise_sig;
    plot(ip_sig);
    axis(handles.axes_noise,[0 1e4 -1.5 1.5]);
    title('Input Signal','FontSize', fontSize);
    xlabel('Time', 'FontSize', fontSize);
    ylabel('Amplitude', 'FontSize', fontSize);
% Hint: get(hObject,'Value') returns toggle state of rdob_p


% --- Executes on button press in rdob_ph.
function rdob_ph_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.noise_lambda, 'Enable','off');
set(handles.ok_noise_lambda, 'Enable','off');
set(handles.sigma_noise, 'Enable','off');
set(handles.ok_sigma_noise, 'Enable','off');
% Hint: get(hObject,'Value') returns toggle state of rdob_ph


% --- Executes on button press in rdob_s.
function rdob_s_Callback(hObject, eventdata, handles)
% hObject    handle to rdob_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.noise_lambda, 'Enable','on');
    set(handles.ok_noise_lambda, 'Enable','on');
    set(handles.sigma_noise, 'Enable','off');
    set(handles.ok_sigma_noise, 'Enable','off');

% Hint: get(hObject,'Value') returns toggle state of rdob_s
%% ==============================================**********==============================================


%% ===============================================  AXES  ===============================================
% --- Executes during object creation, after setting all properties.
function axes_waveform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_waveform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_waveform


% --- Executes during object creation, after setting all properties.
function axes_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_noise


% --- Executes during object creation, after setting all properties.
function axes_filt_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_filt_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    global lmsAxesStatus;
    global filtSig;
    global fontSize;
    if(lmsAxesStatus == 1)
        
        % set axis properties
        axes(handles.axes_filt_signal);
        zoom xon
        
        plot(filtSig);
        
        axis(handles.axes_filt_signal,[0 1e4 -1.5 1.5]);
        title('Filtered Signal','FontSize', fontSize);
        xlabel('Time', 'FontSize', fontSize);
        ylabel('Amplitude', 'FontSize', fontSize);
    end;
% Hint: place code in OpeningFcn to populate axes_filt_signal


% --- Executes during object creation, after setting all properties.
function axes_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_signal


% --- Executes during object creation, after setting all properties.
function axes_learn_curve_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_learn_curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    global lmsAxesStatus;
    global errlc;
    global fontSize;
    if(lmsAxesStatus == 1)
        
        % set axis properties
        axes(handles.axes_learn_curve);
        zoom xon
        
        plot(errlc);
        
        axis(handles.axes_learn_curve,[0 1e4 -1 1.5]);
        title('Learning Curve','FontSize', fontSize);
        xlabel('Iterations', 'FontSize', fontSize);
        ylabel('Amplitude', 'FontSize', fontSize);
    end;
% Hint: place code in OpeningFcn to populate axes_learn_curve

%% ==============================================**********==============================================
