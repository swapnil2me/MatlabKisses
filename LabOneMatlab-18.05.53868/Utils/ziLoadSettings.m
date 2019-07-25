function ziLoadSettings(device, filename)
% ZILOADSETTINGS load a LabOne settings file to the specified device.
% 
% ZILOADSETTINGS(DEVICE, FILENAME)
%
% Load the settings from the LabOne settings file FILENAME to the specified
% DEVICE, e.g., 'dev1234'.
% 
% EXAMPLES 
% 
% Load a settings file located in the current directory:
%
%   ziAutoConnect()
%   dev = ziAutoDetect()
%   ziLoadSettings(dev, 'my_settings.xml')
% 
% Load a settings file from the default LabOne settings path:
%
%   ziAutoConnect()
%   dev = ziAutoDetect()
%   filename = 'default_ui.xml'
%   default_path = ziGetDefaultSettingsPath()
%   ziLoadSettings(dev, [default_path, filesep, 'default_ui.xml'])
%
% See also ZISAVESETTINGS, ZIGETDEFAULTSETTINGSPATH.

  if nargin < 2
    error('ziLoadSettings: Two input arguments required, a device and filename (both character arrays).');
  end
  if ~ischar(device)
    error('ziLoadSettings: device should be a character array.');
  end
  if ~ischar(filename)
    error('ziLoadSettings: filename should be a character array.');
  end
  
  [path, filename_noext, ext] = fileparts(filename);
  h = ziDAQ('deviceSettings');
  
  ziDAQ('set', h, 'deviceSettings/device', device);
  ziDAQ('set', h, 'deviceSettings/filename', filename_noext);
  if path
    ziDAQ('set', h, 'deviceSettings/path', path);
  else
    ziDAQ('set', h, 'deviceSettings/path', ['.', filesep]);
  end
  ziDAQ('set', h, 'deviceSettings/command', 'load');
  try
    ziDAQ('execute', h);
    tic;
    timeout = 60.0;  % seconds
    while ~ziDAQ('finished', h)
      pause(0.05);
      if toc > timeout
        error('Unable to load device settings after %.2f seconds', timeout)
      end
    end
  catch err
    ziDAQ('clear', h)
    rethrow(err);
  end
  ziDAQ('clear', h)
  
end
