function data = example_swtrigger_digital(device_id, varargin)
% EXAMPLE_SWTRIGGER_DIGITAL Record data using a digital trigger via ziDAQ's record module
%
% USAGE DATA = EXAMPLE_SWTRIGGER_DIGITAL(DEVICE_ID)
%
% Record demodulator sample data using a software trigger from ziDAQ's
% 'record' module. This example records segments of demodulator data upon a
% rising edge of the digital input (DIO connector).
%
% The record module implements software triggering analogously to the types of
% triggering found in spectroscopes.
%
% NOTE Additional configuration: Connect signal output 1 to signal input 1
% with a BNC cable.
%
% NOTE Please ensure that the ziDAQ folders 'Driver' and 'Utils' are in your
% Matlab path. To do this (temporarily) for one Matlab session please navigate
% to the ziDAQ base folder containing the 'Driver', 'Examples' and 'Utils'
% subfolders and run the Matlab function ziAddPath().
% >>> ziAddPath;
%
% Use either of the commands:
% >>> help ziDAQ
% >>> doc ziDAQ
% in the Matlab command window to obtain help on all available ziDAQ commands.
%
% Copyright 2008-2018 Zurich Instruments AG

clear ziDAQ;

if ~exist('device_id', 'var')
    error(['No value for device_id specified. The first argument to the ' ...
           'example should be the device ID on which to run the example, ' ...
           'e.g. ''dev2006'' or ''uhf-dev2006''.'])
end

% Check the ziDAQ MEX (DLL) and Utility functions can be found in Matlab's path.
if ~(exist('ziDAQ') == 3) && ~(exist('ziCreateAPISession', 'file') == 2)
    fprintf('Failed to either find the ziDAQ mex file or ziDevices() utility.\n')
    fprintf('Please configure your path using the ziDAQ function ziAddPath().\n')
    fprintf('This can be found in the API subfolder of your LabOne installation.\n');
    fprintf('On Windows this is typically:\n');
    fprintf('C:\\Program Files\\Zurich Instruments\\LabOne\\API\\MATLAB2012\\\n');
    return
end

% The API level supported by this example.
apilevel_example = 6;
% Create an API session; connect to the correct Data Server for the device.
[device, props] = ziCreateAPISession(device_id, apilevel_example);
ziApiServerVersionCheck();

branches = ziDAQ('listNodes', ['/' device ], 0);
if ~any(strcmp([branches], 'DEMODS'))
  data = [];
  fprintf('\nThis example requires lock-in functionality which is not available on %s.\n', device);
  return
end

% Define parameters relevant to this example. Default values specified by the
% inputParser below are overwritten if specified as name-value pairs via the
% `varargin` input argument.
p = inputParser;
isnonnegscalar = @(x) isnumeric(x) && isscalar(x) && (x > 0);
isnonnegvector = @(x) isnumeric(x) && isvector(x) && all(x > 0);

% The indices of the demodulators to record for the experiment, 1-based
% indexing.
p.addParamValue('demod_idx', [1], isnonnegvector);

% The signal output mixer amplitude, [V].
p.addParamValue('amplitude', 0.5, @isnumeric);

% The value used for the SW Trigger's 'trigger/0/count' parameter: This
% specifies the number of signal segments to record.
p.addParamValue('trigger_count', 10, @isnumeric);

% The value used for the SW Trigger's 'trigger/0/duration' parameter: This is
% the duration in seconds of signal segment to record.
p.addParamValue('trigger_duration', 1.0, @isnumeric);

% The value used for the SW Trigger's 'trigger/0/delay' parameter: This
% specifies the delay in seconds to wait before recording the signal after the
% point in the time when the trigger is activated. A negative value indicates
% a pretrigger time.
p.addParamValue('trigger_delay', -0.1, @isnumeric);
p.parse(varargin{:});
demod_idx = p.Results.demod_idx;
amplitude = p.Results.amplitude;
trigger_count = p.Results.trigger_count;
trigger_duration = p.Results.trigger_duration;
trigger_delay = p.Results.trigger_delay;

% Define some other helper parameters.
demod_rate = 2e3;
time_constant = 0.001; % [s]

% The varialbe demod_idx is for accessing the data in Matlab and are therefore
% 1-based indexed. The node paths corresponding to the setting on the
% instrument use 0-based indexing.
demod_c = zeros(size(demod_idx));
for ii=demod_idx
    demod_c(ii) = num2str(demod_idx(ii) - 1, '%0d');
end
out_c = '0';
% Get the value of the instrument's default Signal Output mixer channel.
out_mixer_c = num2str(ziGetDefaultSigoutMixerChannel(props, str2num(out_c)));
in_c = '0';
osc_c = '0';

% Create a base configuration: Disable all available outputs, awgs,
% demods, scopes,...
ziDisableEverything(device);

%% configure the device ready for this experiment.
ziDAQ('setInt', ['/' device '/sigins/' in_c '/imp50'], 0);
ziDAQ('setInt', ['/' device '/sigins/' in_c '/ac'], 0);
ziDAQ('setDouble', ['/' device '/sigins/' in_c '/range'], 2);
ziDAQ('setInt', ['/' device '/sigouts/' out_c '/on'], 1);
ziDAQ('setDouble', ['/' device '/sigouts/' out_c '/range'], 1);
ziDAQ('setDouble', ['/' device '/sigouts/' out_c '/amplitudes/*'], 0);
ziDAQ('setDouble', ['/' device '/sigouts/' out_c '/amplitudes/' out_mixer_c], amplitude);
ziDAQ('setDouble', ['/' device '/sigouts/' out_c '/enables/' out_mixer_c], 1);
if strfind(props.devicetype, 'HF2')
    ziDAQ('setInt', ['/' device '/sigins/' in_c '/diff'], 0);
    ziDAQ('setInt', ['/' device '/sigouts/' out_c '/add'], 0);
end
ziDAQ('setDouble', ['/' device '/demods/*/phaseshift'], 0);
ziDAQ('setInt', ['/' device '/demods/*/order'], 8);
for d=demod_c
    ziDAQ('setDouble', ['/' device '/demods/' d '/rate'], demod_rate);
end
ziDAQ('setInt', ['/' device '/demods/' demod_c(1) '/harmonic'], 1);
for d=demod_c
    ziDAQ('setInt', ['/' device '/demods/' d '/enable'], 1);
end
ziDAQ('setInt', ['/' device '/demods/*/oscselect'], str2double(osc_c));
ziDAQ('setInt', ['/' device '/demods/*/adcselect'], str2double(in_c));
ziDAQ('setDouble', ['/' device '/demods/*/timeconstant'], time_constant);
ziDAQ('setDouble', ['/' device '/oscs/' osc_c '/freq'], 400e3); % [Hz]

% Unsubscribe from any streaming data.
ziDAQ('unsubscribe', '*');

% Wait for the demodulator filter to settle.
pause(10*time_constant);

% Create a recorder thread, the return argument is a handle to the recorder
% (thread).
h = ziDAQ('record');

% Device on which trigger will be performed
ziDAQ('set', h, 'trigger/device', device)
% Configure the recorder
ziDAQ('set', h, 'trigger/0/count', trigger_count);
%   type:
%     NO_TRIGGER = 0
%     EDGE_TRIGGER = 1
%     DIGITAL_TRIGGER = 2
%     PULSE_TRIGGER = 3
%     TRACKING_TRIGGER = 4
ziDAQ('set', h, 'trigger/0/type', 2);
%   triggernode, specify the triggernode to trigger on.
%     SAMPLE.X = Demodulator X value
%     SAMPLE.Y = Demodulator Y value
%     SAMPLE.R = Demodulator Magnitude
%     SAMPLE.THETA = Demodulator Phase
%     SAMPLE.AUXIN0 = Auxilliary input 1 value
%     SAMPLE.AUXIN1 = Auxilliary input 2 value
%     SAMPLE.DIO = Digital I/O value
%   Here we use the device's DIO value which is included in a demodulator sample:
triggernode = ['/' device '/demods/' num2str(demod_idx(1) - 1, '%0d') '/sample.dio'];
ziDAQ('set', h, 'trigger/0/triggernode', triggernode);
%   edge:
%     POS_EDGE = 1
%     NEG_EDGE = 2
%     BOTH_EDGE = 3
ziDAQ('set', h, 'trigger/0/edge', 1)
% The size of the internal buffer used to store data, this should be larger
% than trigger_duration.
ziDAQ('set', h, 'trigger/buffersize', 2*trigger_duration);
% The length of each trigger to record (in seconds).
ziDAQ('set', h, 'trigger/0/duration', trigger_duration);
ziDAQ('set', h, 'trigger/0/bitmask', 1)
ziDAQ('set', h, 'trigger/0/bits', 1)
ziDAQ('set', h, 'trigger/0/delay', trigger_delay)
ziDAQ('set', h, 'trigger/0/retrigger', 0)
ziDAQ('set', h, 'trigger/0/holdoff/time', 0.1)
ziDAQ('set', h, 'trigger/0/holdoff/count', 0)
% parameters not needed for digital triggers
% ziDAQ('set', h, 'trigger/0/level', 0.1)
% ziDAQ('set', h, 'trigger/0/hysteresis', 0.01)

%% Start recording
% Subscribe all demodulators
ziDAQ('subscribe', h, ['/' device '/demods/' demod_c(1) '/sample']);

% now start the thread -> ready to be triggered
ziDAQ('execute', h);

% In order to demonstrate the digital trigger artificially generate a pulse
% on the DIO, this is not part of the record module functionality.
% Here, configure the DIO
ziDAQ('setInt', ['/' device '/dios/0/drive'], 1);
ziDAQ('setInt', ['/' device '/dios/0/output'], 0);

timeout = 20; % [s]
triggers = 0;
n = 0;
tic;
while ~ziDAQ('finished', h)
    fprintf(repmat('\b', 1, n-1));
    msg = sprintf('Recorder progress (acquiring %d triggers): %.1f%%%%', ...
                  trigger_count, 100*ziDAQ('progress', h));
    fprintf(msg);
    n=numel(msg);
% In order to demonstrate the digital trigger artificially generate a pulse
% on the DIO, this is not part of the record module functionality.
% Here, generate the pulse
    ziDAQ('setInt', ['/' device '/dios/0/output'], 1); pause(0.2);
    ziDAQ('setInt', ['/' device '/dios/0/output'], 0);
    pause(0.8);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% It is also possible to read intermediate data. In this case the data between
% reads is not acculmulated in the module - it is cleared, so that the next
% time you do a read you (should) only get the triggers that came inbetween
% the two reads.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Leave this part out if you're not interested in intermediate data
%  data = ziDAQ('read', h);
%   if isfield(data, device)
%     data = data.(device);
%     if isfield(data, 'demods')
%       if ~isempty(data.demods(demod_idx(1)).sample)
%         fprintf('t: %d, len: %d\n', triggers, length(data.demods(demod_idx(1)).sample))
%         for i=1:length(data.demods(demod_idx(1)).sample)
%           fprintf('t: %.20d\n', data.demods(demod_idx(1)).sample{i}.timestamp(1));
%         end
%         triggers = triggers + length(data.demods(demod_idx(1)).sample);
%         fprintf('Recorded %d data segments.\n', triggers);
%       end
%     end
%   end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% timeout check
    if toc > timeout
    % If for some reason the trigger is missing
    % the following command will force the end of the
    % measurement
        fprintf('\nStill no trigger found. Will force finish.\n')
        ziDAQ('finish', h);
    end
    if triggers >= trigger_count
        ziDAQ('finish', h);
    end
end
fprintf('\n');

% now read the data. this command can also be executed during waiting (see
% above). in this case trigger data up to that time point is returned. But we
% then still need on read command at the end to fetch the rest.
data = ziDAQ('read', h);
ziDAQ('unsubscribe', h, ['/' device '/demods/*/sample']);
ziDAQ('clear', h);

% process the read data
if isfield(data, device)
    if isfield(data.(device), 'demods')
        if ~isempty(data.(device).demods(demod_idx(1)).sample)
            % as we may get several trigger segments back we use cells to
            % address the individual segments
            triggers = length(data.(device).demods(demod_idx(1)).sample);
            fprintf('Recorded %d data segments (expected %d).\n', triggers, trigger_count);
            if data.(device).demods(demod_idx(1)).sample{end}.time.dataloss
                fprintf('Warning: Sample loss detected.');
            end
            % plot the last trigger
            r1 = abs(data.(device).demods(demod_idx(1)).sample{end}.x + j*data.(device).demods(demod_idx(1)).sample{end}.y);

            % Convert timestamps from ticks to seconds via the device's clockbase
            % (the ADC's sampling rate)
            clockbase = double(ziDAQ('getInt', ['/' device '/clockbase']));
            t1 = double(data.(device).demods(demod_idx(1)).sample{end}.timestamp)/clockbase;
            bits1 = bitand(1, double(data.(device).demods(demod_idx(1)).sample{end}.bits));
            rmean = mean(r1);

            % The trigger timestamp is the timestamp at which the trigger
            % criteria was fulfilled and has in general a higher resolution
            % than the demodulator rate.
            t_trigger = double(data.(device).demods(demod_idx(1)).sample{end}.time.trigger)/clockbase;

            figure(1); clf;
            box on; grid on;
            % Note: we always use the timestamp from the demod whose data we
            % want to plot. If we only use the timestamps from one demod,
            % e.g. t1, we may have inconsistent data (e.g, . different lengths
            % from dataloss).
            s = plot(t1 - t_trigger, r1, ...
                     t1 - t_trigger, bits1);
            set(s, 'LineWidth', 2);
            xlabel('Time [s] relative to trigger position')
            ylabel('Signal');
            legend(s, 'Demod R', 'DIO 0');
            grid on;
            box on;
            fprintf('Measured RMS amplitude: %g V.\n', rmean);
        end
    end
end

end
