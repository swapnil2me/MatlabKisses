%
% Copyright 2009-2018, Zurich Instruments Ltd, Switzerland
% This software is a preliminary version. Function calls and
% parameters may change without notice.
%
% This version of ziDAQ is linked against:
% * Matlab 7.9.0.529, R2009b, Windows,
% * Matlab 8.4.0.145, R2014b, Linux64.
% You can check which version of Matlab you are using Matlab's `ver` command.
% A list of compatible Matlab and ziDAQ versions is available here:
% www.zhinst.com/labone/compatibility
%
% ziDAQ is an interface for communication with Zurich Instruments Data Servers.
%
% Usage: ziDAQ(command, [option1], [option2])
%        command = 'awgModule', 'clear', 'connect', 'connectDevice',
%                  'dataAcquisitionModule', 'deviceSettings',
%                  'disconnectDevice', 'discoveryFind', 'discoveryGet',
%                  'finished', 'flush', 'get', 'getAsEvent', 'getAuxInSample',
%                  'getByte', 'getDIO', 'getDouble', 'getInt', 'getString',
%                  'getSample', 'help', 'impedanceModule',
%                  'listNodes', 'listNodesJSON', 'logOn',
%                  'logOff', 'multiDeviceSyncModule', 'pidAdvisor',
%                  'poll', 'pollEvent', 'programRT', 'progress',
%                  'read', 'record', 'setByte', 'setDouble', 'syncSetDouble',
%                  'setInt', 'syncSetInt', 'setString', 'syncSetString',
%                  'subscribe', 'sweep', 'unsubscribe', 'update',
%                  'zoomFFT'
%
% Preconditions: ZI Server must be running (check task manager)
%
%            ziDAQ('connect', [host = '127.0.0.1'], [port = 8005], [apiLevel = 1]);
%                  [host] = Server host string (default is localhost)
%                  [port] = Port number (double)
%                           Use port 8005 to connect to the HF2 Data Server
%                           Use port 8004 to connect to the MF or UHF Data Server
%                  [apiLevel] = Compatibility mode of the API interface (int64)
%                           Use API level 1 to use code written for HF2.
%                           Higher API levels are currently only supported
%                           for MF and UHF devices. To get full functionality for
%                           MF and UHF devices use API level 5.
%                  To disconnect use 'clear ziDAQ'
%
%   result = ziDAQ('getConnectionAPILevel');
%                  Returns ziAPI level used for the active connection.
%
%   result = ziDAQ('discoveryFind', device);
%                  device (string) = Device address string (e.g. 'UHF-DEV2000')
%                  Return the device ID for a given device address.
%
%   result = ziDAQ('discoveryGet', deviceId);
%                  deviceId (string) = Device id string (e.g. DEV2000)
%                  Return the device properties for a given device id.
%
%            ziDAQ('connectDevice', device, interface);
%                  device (string) = Device serial to connect (e.g. 'DEV2000')
%                  interface (string) = Interface, e.g., 'USB', '1GbE'.
%                  Connect with the data server to a specified device over the
%                  specified interface. The device must be visible to the server.
%                  If the device is already connected the call will be ignored.
%                  The function will block until the device is connected and
%                  the device is ready to use. This method is useful for UHF
%                  devices offering several communication interfaces.
%
%            ziDAQ('disconnectDevice', device);
%                  device (string) = Device serial of device to disconnect.
%                  This function will return immediately. The disconnection of
%                  the device may not yet finished.
%
%   result = ziDAQ('listNodes', path, flags);
%                  path (string) = Node path or partial path, e.g.,
%                           '/dev100/demods/'.
%                  flags (int64) = Define which nodes should be returned, set the
%                          following bits to obtain the described behavior:
%                          int64(0) -> ZI_LIST_NODES_NONE 0x00
%                            The default flag, returning a simple
%                            listing of the given node
%                          int64(1) -> ZI_LIST_NODES_RECURSIVE 0x01
%                            Returns the nodes recursively
%                          int64(2) -> ZI_LIST_NODES_ABSOLUTE 0x02
%                            Returns absolute paths
%                          int64(4) -> ZI_LIST_NODES_LEAFSONLY 0x04
%                            Returns only nodes that are leafs,
%                            which means the they are at the
%                            outermost level of the tree.
%                          int64(8) -> ZI_LIST_NODES_SETTINGSONLY 0x08
%                            Returns only nodes which are marked
%                            as setting
%                          int64(16) -> ZI_LIST_NODES_STREAMINGONLY 0x10
%                            Returns only streaming nodes
%                          int64(32) -> ZI_LIST_NODES_SUBSCRIBEDONLY 0x20
%                            Returns only subscribed nodes
%                  Returns a list of nodes with description found at the specified
%                  path. Flags may also be combined, e.g., set flags to bitor(1, 2)
%                  to return paths recursively and printed as absolute paths.
%
%   result = ziDAQ('listNodesJSON', path, flags);
%                  path (string) = Node path or partial path, e.g.,
%                           '/dev100/demods/'.
%                  flags (int64) = Define which nodes should be returned, set the
%                          following bits to obtain the described behavior.
%                          They are the same as for listNodes(), except that
%                          0x01, 0x02 and 0x04 are enforced:
%                          int64(8) -> ZI_LIST_NODES_SETTINGSONLY 0x08
%                            Returns only nodes which are marked
%                            as setting
%                          int64(16) -> ZI_LIST_NODES_STREAMINGONLY 0x10
%                            Returns only streaming nodes
%                          int64(32) -> ZI_LIST_NODES_SUBSCRIBEDONLY 0x20
%                            Returns only subscribed nodes
%                          int64(64) -> ZI_LIST_NODES_BASECHANNEL 0x40
%                            Return only one instance of a node in case of multiple
%                            channels
%                  Returns a list of nodes with description found at the specified
%                  path as a JSON formatted string. Only UHF and MF devices support
%                  this functionality. Flags may also be combined, e.g., set flags
%                  to bitor(1, 2) to return paths recursively and printed as
%                  absolute paths.
%
%   result = ziDAQ('help', path);
%                  path (string) = Node path or partial path, e.g.,
%                           '/dev100/demods/'.
%                  Returns a formatted description of the nodes in the supplied path.
%                  Only UHF and MF devices support this functionality.
%
%   result = ziDAQ('getSample', path);
%                  path (string) = Node path
%                  Returns a single demodulator sample (including
%                  DIO and AuxIn). For more efficient data recording
%                  use the subscribe and poll functions.
%
%   result = ziDAQ('getAuxInSample', path);
%                  path (string) = Node path
%                  Returns a single auxin sample. Note, the auxin data
%                  is averaged in contrast to the auxin data embedded
%                  in the demodulator sample.
%
%   result = ziDAQ('getDIO', path);
%                  path (string) = Node path.
%                  Returns a single DIO sample.
%
%   result = ziDAQ('getDouble', path);
%                  path (string) = Node path
%
%   result = ziDAQ('getInt', path);
%                  path (string) = Node path
%
%   result = ziDAQ('getByte', path);
%                  path (string) = Node path
%
%   result = ziDAQ('getString', path);
%                  path (string) = Node path
%
%            ziDAQ('setDouble', path, value);
%                  path (string) = Node path
%                  value (double) = Setting value
%
%            ziDAQ('syncSetDouble', path, value);
%                  Deprecated, see the 'sync' command.
%                  path (string) = Node path
%                  value (double) = Setting value
%
%            ziDAQ('setInt', path, value);
%                  path (string) = Node path
%                  value (int64) = Setting value
%
%            ziDAQ('syncSetInt', path, value);
%                  Deprecated, see the 'sync' command.
%                  path (string) = Node path
%                  value (int64) = Setting value
%
%            ziDAQ('setByte', path, value);
%                  path (string) = Node path
%                  value (double) = Setting value
%
%            ziDAQ('setString', path, value);
%                  path (string) = Node path
%                  value (string) = Setting value
%
%            ziDAQ('syncSetString', path, value);
%                  path (string) = Node path
%                  value (string) = Setting value
%
%            ziDAQ('asyncSetString', path, value);
%                  path (string) = Node path
%                  value (string) = Setting value
%
%            ziDAQ('vectorWrite', path, value);
%                  path (string) = Vector node path
%                  value (vector of (u)int8, (u)int16, (u)int32, (u)int64,
%                         float, double; or string) = Setting value
%
%            ziDAQ('subscribe', path);
%                  path (string) = Node path
%                  Subscribe to the specified path to receive streaming data
%                  or setting data if changed. Use either 'poll' command to
%                  obtain the subscribed data.
%
%            ziDAQ('unsubscribe', path);
%                  path (string) = Node path
%                  Unsubscribe from the node paths specified via 'subscribe'.
%                  Use a wildcard ('*') to unsubscribe from all data.
%
%            ziDAQ('getAsEvent', path);
%                  path (string) = Node path
%                  Triggers a single event on the path to return the current
%                  value. The result can be fetched with the 'poll' or 'pollEvent'
%                  command.
%
%            ziDAQ('update');
%                  Detect HF2 devices connected to the USB. On Windows this
%                  update is performed automatically.
%
%            ziDAQ('get', path, [settingsOnly]);
%                  path (string) = Node path
%                  Gets a structure of the node data from the specified
%                  branch. High-speed streaming nodes (e.g. /devN/demods/0/sample)
%                  are not returned. Wildcards (*) may be used, in which case
%                  read-only nodes are ignored.
%                  [settginsOnly] (uint32) = Specify which type of nodes to include
%                  in the result. Allowed:
%                            ZI_LIST_NODES_SETTINGSONLY = 8 (default)
%                            ZI_LIST_NODES_NONE = 0 (all nodes)
%
%            ziDAQ('flush');
%                  Deprecated, see the 'sync' command.
%                  Flush all data in the socket connection and API buffers.
%                  Call this function before a subscribe with subsequent poll
%                  to get rid of old streaming data that might still be in
%                  the buffers.
%
%            ziDAQ('echoDevice', device);
%                  Deprecated, see the 'sync' command.
%                  device (string) = device serial, e.g. 'dev100'.
%                  Sends an echo command to a device and blocks until
%                  answer is received. This is useful to flush all
%                  buffers between API and device to enforce that
%                  further code is only executed after the device executed
%                  a previous command.
%
%            ziDAQ('sync');
%                  Synchronize all data paths. Ensures that get and poll
%                  commands return data which was recorded after the
%                  setting changes in front of the sync command. This
%                  sync command replaces the functionality of all 'syncSet*',
%                  'flush', and 'echoDevice' commands.
%
%            ziDAQ('programRT', device, filename);
%                  device (string) = device serial, e.g. 'dev100'.
%                  filename (string) = filename of RT program.
%                  HF2 devices only; writes down a real-time program. Requires
%                  the Real time Option must be available for the specified
%                  HF2 device.
%
%   result = ziDAQ('secondsTimeStamp', [timestamps]);
%                  timestamps (uint64) = vector of uint64 device ticks
%                  Deprecated. In order to convert timestamps to seconds divide the
%                  timestamps by the value of the instrument's clockbase device node,
%                  e.g., /dev99/clockbase.
%                  [Converts a timestamp vector of uint64 ticks
%                  into a double vector of timestamps in seconds (HF2 Series).]
%
% Synchronous Interface
%
%            ziDAQ('poll', duration, timeout, [flags]);
%                  duration (double) = Time in [s] to continuously check for value
%                                      changes in subscribed nodes before
%                                      returning
%                  timeout (int64)   = Poll timeout in [ms]; recommended: 10 ms
%                  [flags] (uint32)  = Flags specifying data polling properties
%                            Bit[0] FILL : Fill data loss holes
%                            Bit[2] THROW : Throw if data loss is detected (only
%                                   possible in combination with FILL).
%                            Bit[3] DETECT: Just detect data loss holes.
%                  Continuously check for value changes (by calling pollEvent) in
%                  all subscribed nodes for the specified duration and return the
%                  data. If no value change occurs in subscribed nodes before
%                  duration + timeout, poll returns no data. This function call is
%                  blocking (it is synchronous). However, since all value changes
%                  are returned since either subscribing to the node or the last
%                  poll (assuming no buffer overflow has occurred on the Data
%                  Server), this function may be used in a quasi-asynchronous
%                  manner to return data spanning a much longer time than the
%                  specified duration. The timeout parameter is only relevant when
%                  communicating in a slow network. In this case it may be set to
%                  a value larger than the expected round-trip time in the
%                  network.
%
%   result = ziDAQ('pollEvent', timeout);
%                  timeout (int64) = Poll timeout in [ms]
%                  Return the value changes that occurred in one single subscribed
%                  node. This is a low-level function. The poll function is better
%                  suited in nearly all cases.
%
%% LabOne API Modules
% Shared Interface (common for all modules)
%
%   result = ziDAQ('listNodes', handle, path, flags);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Module parameter path
%                  flags (int64) = Define which module parameters paths should be
%                          returned, set the following bits to obtain the
%                          described behaviour:
%                  flags = int64(0) -> ZI_LIST_NODES_NONE 0x00
%                            The default flag, returning a simple
%                            listing of the given path
%                          int64(1) -> ZI_LIST_NODES_RECURSIVE 0x01
%                            Returns the paths recursively
%                          int64(2) -> ZI_LIST_NODES_ABSOLUTE 0x02
%                            Returns absolute paths
%                          int64(4) -> ZI_LIST_NODES_LEAFSONLY 0x04
%                            Returns only paths that are leafs,
%                            which means the they are at the
%                            outermost level of the tree.
%                          int64(8) -> ZI_LIST_NODES_SETTINGSONLY 0x08
%                            Returns only paths which are marked
%                            as setting
%                  Flags may also be combined, e.g., set flags to bitor(1, 2)
%                  to return paths recursively and printed as absolute paths.
%
%            ziDAQ('subscribe', handle, path);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Node path to process data received from the
%                           device. Use wildcard ('*') to select all.
%                  Subscribe to device nodes. Call multiple times to
%                  subscribe to multiple node paths. After subscription the
%                  processing can be started with the 'execute'
%                  command. During the processing paths can not be
%                  subscribed or unsubscribed.
%
%            ziDAQ('unsubscribe', handle, path);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Node path to process data received from the
%                           device. Use wildcard ('*') to select all.
%                  Unsubscribe from one or several nodes. During the
%                  processing paths can not be subscribed or
%                  unsubscribed.
%
%            ziDAQ('getInt', handle, path);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Path string of the module parameter. Must
%                           start with the module name.
%                  Get integer module parameter. Wildcards are not supported.
%
%            ziDAQ('getDouble', handle, path);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Path string of the module parameter. Must
%                           start with the module name.
%                  Get floating point double module parameter. Wildcards are not
%                  supported.
%
%            ziDAQ('getString', handle, path);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Path string of the module parameter. Must
%                           start with the module name.
%                  Get string module parameter. Wildcards are not supported.
%
%            ziDAQ('get', handle, path);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Path string of the module parameter. Must
%                           start with the module name.
%                  Get module parameters. Wildcards are supported, e.g. 'sweep/*'.
%
%            ziDAQ('set', handle, path, value);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  path (string) = Path string of the module parameter. Must
%                           start with the module name.
%                  value = The value to set the module parameter to, see the list
%                           of module parameters for the correct type.
%                  Set the specified module parameter value.
%
%            ziDAQ('execute', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  Start the module thread. Subscription or unsubscription
%                  is not possible until the module is finished.
%
%   result = ziDAQ('finished', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  Returns 1 if the processing is finished, otherwise 0.
%
%   result = ziDAQ('read', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  Read out the recorded data; transfer the module data to
%                  Matlab.
%
%            ziDAQ('finish', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  Stop executing. The thread may be restarted by
%                  calling 'execute' again.
%
%   result = ziDAQ('progress', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  Report the progress of the measurement with a number
%                  between 0 and 1.
%
%            ziDAQ('clear', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the module class.
%                  Stop the module's thread.
%
%
%% SW Trigger Module
%
%   handle = ziDAQ('record' duration, timeout);
%                  duration (double) = The module's internal buffersize to use when
%                                      recording data [s]. The recommended size is
%                                      2*trigger/0/duration parameter. Note that
%                                      this can be modified via the
%                                      trigger/buffersize parameter.
%                                      DEPRECATED, set 'buffersize' param instead.
%                  timeout (int64) = Poll timeout [ms]. - DEPRECATED, ignored
%                  Create an instance of the ziDAQRecorder and return a Matlab
%                  handle with which to access it.
%                  Before the module can actually be started (via 'execute'):
%                  - the desired data to record must be specified via the module's
%                    'subscribe' command,
%                  - the device serial (e.g., dev100) that will be used must be
%                    set.
%                  The real measurement is started upon calling the 'execute'
%                  function. After that the module will start recording data and
%                  verifying for incoming triggers.
%
%            ziDAQ('trigger', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the ziDAQRecorder class.
%                  Force a trigger to manually record one duration of the
%                  subscribed data.
%
%   Trigger Parameters
%     trigger/buffersize         double Set the buffersize [s] of the trigger
%                                       object. The recommended buffer size is
%                                       2*trigger/0/duration.
%     trigger/flags              int    Record flags.
%                                       FILL  = 0x0001 : Fill holes.
%                                       ALIGN = 0x0002 : Align data that contains a
%                                                        timestamp.
%                                       THROW = 0x0004 : Throw if sample loss
%                                                        is detected.
%                                       DETECT = 0x0008: Just detect data loss holes.
%     trigger/device             string The device serial to use the software trigger
%                                       with, e.g. dev123 (compulsory parameter).
%     trigger/endless            bool   Enable endless triggering 1=enable;
%                                       0=disable.
%     trigger/forcetrigger       bool   Force a trigger.
%     trigger/awgcontrol         bool   Enable interaction with AWG. If enabled the
%                                       hwtrigger index counter will be used to
%                                       control the grid row for recording.
%     trigger/0/triggernode      string Path and signal of the node that should be
%                                       used for triggering, separated by a dot (.),
%                                       e.g. /devN/demods/0/sample.x
%                                       Overrides values from trigger/0/path and
%                                       trigger/0/source.
%     trigger/0/path             string The path to the demod sample to trigger on,
%                                       e.g. demods/3/sample, see also
%                                       trigger/0/source
%                                       DEPRECATED - use trigger/0/triggernode
%                                       instead
%     trigger/0/source           int    Signal that is used to trigger on.
%                                       0 = x
%                                       1 = y
%                                       2 = r
%                                       3 = angle
%                                       4 = frequency
%                                       5 = phase
%                                       6 = auxiliary input 0 / parameter 0
%                                       7 = auxiliary input 1 / parameter 1
%                                       DEPRECATED - use trigger/0/triggernode
%                                       instead
%     trigger/0/count            int    Number of trigger edges to record.
%     trigger/0/type             int    Trigger type used. Some parameters are
%                                       only valid for special trigger types.
%                                       0 = trigger off
%                                       1 = analog edge trigger on source
%                                       2 = digital trigger mode on DIO source
%                                       3 = analog pulse trigger on source
%                                       4 = analog tracking trigger on source
%                                       5 = change trigger
%                                       6 = hardware trigger on trigger line
%                                           source
%                                       7 = tracking edge trigger on source
%                                       8 = event count trigger on counter source
%     trigger/0/edge             int    Trigger edge
%                                       1 = rising edge
%                                       2 = falling edge
%                                       3 = both
%     trigger/0/findlevel        bool   Automatically find the value of
%                                       trigger/0/level
%                                       based on the current signal value.
%     trigger/0/bits             int    Digital trigger condition.
%     trigger/0/bitmask          int    Bit masking for bits used for
%                                       triggering. Used for digital trigger.
%     trigger/0/delay            double Trigger frame position [s] (left side)
%                                       relative to trigger edge.
%                                       delay = 0 -> trigger edge at left border.
%                                       delay < 0 -> trigger edge inside trigger
%                                                    frame (pretrigger).
%                                       delay > 0 -> trigger edge before trigger
%                                                    frame (posttrigger).
%     trigger/0/duration         double Recording frame length [s]
%     trigger/0/level            double Trigger level voltage [V].
%     trigger/0/hysteresis       double Trigger hysteresis [V].
%     trigger/0/retrigger        int    Record more than one trigger in a trigger
%                                       frame. If a trigger event is currently being
%                                       recorded and another trigger event is
%                                       detected within the duration of the current
%                                       trigger event, extend the size of the
%                                       trigger frame to include the duration of the
%                                       new trigger event.
%     trigger/triggered          bool   Has the software trigger triggered? 1=Yes,
%                                       0=No (read only).
%     trigger/0/bandwidth        double Filter bandwidth [Hz] for pulse and
%                                       tracking triggers.
%     trigger/0/holdoff/count    int    Number of skipped triggers until the
%                                       next trigger is recorded again.
%     trigger/0/holdoff/time     double Hold off time [s] before the next
%                                       trigger is recorded again. A hold off
%                                       time smaller than the duration will
%                                       produce overlapped trigger frames.
%     trigger/0/hwtrigsource     int    Only available for devices that support
%                                       hardware triggering. Specify the channel
%                                       to trigger on.
%                                       DEPRECATED - use trigger/0/triggernode
%                                       instead
%     trigger/0/pulse/min        double Minimal pulse width [s] for the pulse
%                                       trigger.
%     trigger/0/pulse/max        double Maximal pulse width [s] for the pulse
%                                       trigger.
%     trigger/0/eventcount/mode  int    Specifies the mode used for event count
%                                       processing.
%                                       0 - Trigger on every event count sample
%                                       1 - Trigger if event count value incremented
%     trigger/0/grid/mode        int    Enable grid mode. In grid mode a matrix
%                                       instead of a vector is returned. Each
%                                       trigger becomes a row in the matrix and each
%                                       trigger's data is interpolated onto a new
%                                       grid defined by the number of columns:
%                                       0: Disable
%                                       1: Enable with nearest neighbour
%                                          interpolation
%                                       2: Enable with linear interpolation.
%     trigger/0/grid/operation   int    If running in endless mode, either replace
%                                       or average the data in the grid's matrix.
%     trigger/0/grid/cols        int    Specify the number of columns in the grid's
%                                       matrix. The data from each row is
%                                       interpolated onto a grid with the specified
%                                       number of columns.
%     trigger/0/grid/rows        int    Specify the number of rows in the grid's
%                                       matrix. Each row is the data recorded from
%                                       one trigger interpolated onto the columns.
%     trigger/0/grid/repetitions int    Number of statistical operations performed
%                                       per grid.
%     trigger/0/grid/direction   int    The direction to organize data in the grid's
%                                       matrix:
%                                       0: Forward.
%                                          The data in each row is ordered chrono-
%                                          logically, e.g., the first data point in
%                                          each row corresponds to the first
%                                          timestamp in the trigger data.
%                                       1: Reverse.
%                                          The data in each row is ordered reverse
%                                          chronologically, e.g., the first data
%                                          point in each row corresponds to the last
%                                          timestamp in the trigger data.
%                                       2: Bidirectional.
%                                          The ordering of the data alternates
%                                          between Forward and Backward ordering from
%                                          row-to-row. The first row is Forward
%                                          ordered.
%     trigger/save/directory     string The base directory where files are saved.
%     trigger/save/filename      string Defines the sub-directory where files
%                                       are saved. The actual sub-directory
%                                       have this name with a sequence count
%                                       appended, e.g. swtrigger_000.
%     trigger/save/fileformat    string The format of the file for saving data:
%                                       0 = Matlab,
%                                       1 = CSV,
%                                       2 = ZView (Impedance data only).
%     trigger/save/csvseparator  string The character to use as CSV separator when
%                                       saving files in this format.
%     trigger/save/csvlocale     string The locale to use for the decimal point
%                                       character and digit grouping character
%                                       for numerical values in CSV files:
%                                       "C" (default)     = dot for the decimal
%                                                           point and no digit
%                                                           grouping,
%                                       "" (empty string) = use the symbols
%                                                           set in the language
%                                                           and region settings
%                                                           of the computer.
%     trigger/save/save          bool   Initiate the saving of data to file.
%                                       The saving is done in the background
%                                       When the save is finished, this
%                                       parameter goes low.
%     trigger/historylength      bool   Sets an upper limit for the number of
%                                       data captures stored in the module.
%     trigger/clearhistory       bool   Clear all captured data from the module.
%
%
%% Sweep Module
%
%   handle = ziDAQ('sweep', timeout);
%                  timeout = Poll timeout in [ms] - DEPRECATED, ignored
%                  Creates a sweep class. The thread is not yet started.
%                  Before the thread start subscribe and set command have
%                  to be called. To start the real measurement use the
%                  execute function.
%
%   Sweep Parameters
%     sweep/device           string  Device that should be used for
%                                    the parameter sweep, e.g. 'dev99'.
%     sweep/start            double  Sweep start frequency [Hz]
%     sweep/stop             double  Sweep stop frequency [Hz]
%     sweep/gridnode         string  Path of the node that should be
%                                    used for sweeping. For frequency
%                                    sweep applications this will be e.g.
%                                    'oscs/0/freq'. The device name of
%                                    the path can be omitted and is given
%                                    by sweep/device.
%     sweep/loopcount        int     Number of sweep loops (default 1)
%     sweep/endless          int     Endless sweeping (default 0)
%                                    0 = Use loopcount value
%                                    1 = Endless sweeping enabled, ignore
%                                        loopcount
%     sweep/samplecount      int     Number of samples per sweep
%     sweep/settling/time    double  Settling time before measurement is
%                                    performed, in [s]
%     sweep/settling/tc      double  Settling precision
%                                    5 ~ low precision
%                                    15 ~ medium precision
%                                    50 ~ high precision
%     sweep/settling/inaccuracy
%                            int     Demodulator filter settling inaccuracy
%                                    that defines the wait time between a
%                                    sweep parameter change and recording of
%                                    the next sweep point. The settling time
%                                    is calculated as the time required to
%                                    attain the specified remaining proportion
%                                    [1e-13, 0.1] of an incoming step
%                                    function. Typical inaccuracy
%                                    values:
%                                    - 10m for highest sweep speed for large
%                                    signals,
%                                    - 100u for precise amplitude measurements,
%                                    - 100n for precise noise measurements.
%                                    Depending on the order the settling
%                                    accuracy will define the number of filter
%                                    time constants the sweeper has to
%                                    wait. The maximum between this value and
%                                    the settling time is taken as wait time
%                                    until the next sweep point is recorded.
%     sweep/xmapping         int     Sweep mode
%                                    0 = linear
%                                    1 = logarithmic
%     sweep/scan             int     Scan type
%                                    0 = sequential
%                                    1 = binary
%                                    2 = bidirectional
%                                    3 = reverse
%     sweep/bandwidth        double  Fixed bandwidth [Hz]
%                                    0 = Automatic calculation (obsolete)
%     sweep/bandwidthcontrol int     Sets the bandwidth control mode (default 2)
%                                    0 = Manual (user sets bandwidth and order)
%                                    1 = Fixed (uses fixed bandwidth value)
%                                    2 = Auto (calculates best bandwidth value)
%                                        Equivalent to the obsolete bandwidth = 0
%                                        setting
%     sweep/bandwidthoverlap bool    Sets the bandwidth overlap mode (default 0). If
%                                    enabled the bandwidth of a sweep point may
%                                    overlap with the frequency of neighboring sweep
%                                    points. The effective bandwidth is only limited
%                                    by the maximal bandwidth setting and omega
%                                    suppression. As a result, the bandwidth is
%                                    independent of the number of sweep points. For
%                                    frequency response analysis bandwidth overlap
%                                    should be enabled to achieve maximal sweep
%                                    speed (default: 0).
%                                    0 = Disable
%                                    1 = Enable
%     sweep/order            int     Defines the filter roll off to use in Fixed
%                                    bandwidth selection.
%                                    Valid values are between 1 (6 dB/octave)
%                                    and 8 (48 dB/octave). An order of 0
%                                    triggers a read-out of the order from the
%                                    selected demodulator.
%     sweep/maxbandwidth     double  Maximal bandwidth used in auto bandwidth
%                                    mode in [Hz]. The default is 1.25MHz.
%     sweep/omegasuppression double  Damping in [dB] of omega and 2omega components.
%                                    Default is 40dB in favor of sweep speed.
%                                    Use higher value for strong offset values or
%                                    3omega measurement methods.
%     sweep/averaging/tc     double  Min averaging time [tc]
%                                    0 = no averaging (see also time!)
%                                    5 ~ low precision
%                                    15 ~ medium precision
%                                    50 ~ high precision
%     sweep/averaging/sample int     Min samples to average
%                                    1 = no averaging (if averaging/tc = 0)
%     sweep/averaging/time   double  Min averaging time [s]
%     sweep/phaseunwrap      bool    Enable unwrapping of slowly changing phase
%                                    evolutions around the +/-180 degree boundary.
%     sweep/sincfilter       bool    Enables the sinc filter if the sweep frequency
%                                    is below 50 Hz. This will improve the sweep
%                                    speed at low frequencies as omega components
%                                    do not need to be suppressed by the normal
%                                    low pass filter.
%     sweep/awgcontrol       bool    Enable AWG control for sweeper. If enabled
%                                    the sweeper will automatically start the AWG
%                                    and records the sweep sample based on the
%                                    even index in hwtrigger.
%     sweep/save/directory   string  The base directory where files are saved.
%     sweep/save/filename    string  Defines the sub-directory where files are
%                                    saved. The actual sub-directory have this
%                                    name with a sequence count appended, e.g.
%                                    sweep_000.
%     sweep/save/fileformat  string  The format of the file for saving data:
%                                    0 = Matlab,
%                                    1 = CSV,
%                                    2 = ZView (Impedance data only).
%     sweep/save/csvseparator
%                            string The character to use as CSV separator when
%                                   saving files in this format.
%     sweep/save/csvlocale   string The locale to use for the decimal point character
%                                   and digit grouping character for numerical values
%                                   in CSV files:
%                                   "C" (default)     = dot for the decimal point and
%                                                       no digit grouping,
%                                   "" (empty string) = use the symbols set in the
%                                                       language and region settings
%                                                       of the computer.
%     sweep/save/save        bool   Initiate the saving of data to file. The saving
%                                   is done in the background When the save is
%                                   finished, this parameter goes low.
%     sweep/historylength    bool   Maximum number of entries stored in the
%                                   measurement history.
%     sweep/clearhistory     bool   Remove all records from the history list.
%
%     Note:
%     Settling time = max(settling.tc * tc, settling.time)
%     Averaging time = max(averaging.tc * tc, averaging.sample / sample-rate)
%
%
%% Device Settings Module
%
%   handle = ziDAQ('deviceSettings', timeout);
%                  timeout = Poll timeout in [ms] - DEPRECATED, ignored
%                  Creates a device settings class for saving/loading device
%                  settings to/from a file. Before starting the module, set the path,
%                  filename and command parameters. To run the command, use the
%                  execute function.
%
%   Device Settings Parameters
%     deviceSettings/device        string  Device whose settings are to be
%                                          saved/loaded, e.g. 'dev99'.
%     deviceSettings/path          string  Path where the settings files are to
%                                          be located. If not set, the default
%                                          settings location of the LabOne
%                                          software is used.
%     deviceSettings/filename      string  The file to which the settings are to
%                                          be saved/loaded.
%     deviceSettings/command       string  The save/load command to execute.
%                                           'save' = Read device settings and save
%                                                    to file.
%                                           'load' = Load settings from file and
%                                                    write to device.
%                                           'read' = Read device settings only
%                                                    (no save).
%
%
%% PLL Advisor Module, DEPRECATED (use PID Advisor instead)
%
%   The PLL advisor module for the UHF is removed and fully replaced
%   by the generic PID advisor module for all Zurich Instruments devices.
%
%% PID Advisor Module
%
%   PID Advisor Parameters
%     pidAdvisor/advancedmode      int     Disable automatic calculation of the
%                                          start and stop value.
%     pidAdvisor/auto              int     Automatic response calculation triggered
%                                          by parameter change.
%     pidAdvisor/bode              struct  Output parameter. Contains the resulting
%                                          bode plot of the PID simulation.
%     pidAdvisor/bw                double  Output parameter. Calculated system
%                                          bandwidth.
%     pidAdvisor/calculate         int     In/Out parameter. Command to calculate
%                                          values. Set to 1 to start the
%                                          calculation.
%     pidAdvisor/display/freqstart double  Start frequency for Bode plot.
%                                          For disabled advanced mode the start
%                                          value is automatically derived from the
%                                          system properties.
%     pidAdvisor/display/freqstop  double  Stop frequency for Bode plot.
%     pidAdvisor/display/timestart double  Start time for step response.
%     pidAdvisor/display/timestop  double  Stop time for step response.
%     pidAdvisor/dut/bw            double  Bandwidth of the DUT (device under test).
%     pidAdvisor/dut/damping       double  Damping of the second order
%                                          low pass filter.
%     pidAdvisor/dut/delay         double  IO Delay of the feedback system
%                                          describing the earliest response for
%                                          a step change.
%     pidAdvisor/dut/fcenter       double  Resonant frequency of the of the modelled
%                                          resonator.
%     pidAdvisor/dut/gain          double  Gain of the DUT transfer function.
%     pidAdvisor/dut/q             double  quality factor of the modelled resonator.
%     pidAdvisor/dut/source        int     Type of model used for the external
%                                          device to be controlled by the PID.
%                                          source = 1: Low-pass first order
%                                          source = 2: Low-pass second order
%                                          source = 3: Resonator frequency
%                                          source = 4: Internal PLL
%                                          source = 5: VCO
%                                          source = 6: Resonator amplitude
%     pidAdvisor/impulse           struct  Output parameter. Impulse response
%                                          (not yet supported).
%     pidAdvisor/index             int     PID index for parameter detection.
%     pidAdvisor/pid/autobw        int     Adjusts the demodulator bandwidth to fit
%                                          best to the specified target bandwidth
%                                          of the full system.
%     pidAdvisor/pid/d             double  In/Out parameter. Differential gain.
%     pidAdvisor/pid/dlimittimeconstant
%                                  double  In/Out parameter. Differential filter
%                                          timeconstant.
%     pidAdvisor/pid/i             double  In/Out parameter. Integral gain.
%     pidAdvisor/pid/mode          double  Select PID Advisor mode. Mode value is
%                                          bit coded, bit 0: P, bit 1: I, bit 2: D,
%                                          bit 3: D filter limit.
%     pidAdvisor/pid/p             double  In/Out parameter. Proportional gain.
%     pidAdvisor/pid/rate          double  In/Out parameter. PID Advisor sampling
%                                          rate of the PID control loop.
%     pidAdvisor/pid/targetbw      double  PID system target bandwidth.
%     pidAdvisor/todevice          int     Set to 1 to transfer PID advisor
%                                          data to the device.
%     pidAdvisor/type              string  If set to 'pll' for an HF2 device the
%                                          PID advisor will advise parameters for
%                                          the hardware PLL. The default is 'pid'.
%                                          This parameter is only relevant for HF2
%                                          devices.
%     pidAdvisor/pm                double  Output parameter. Simulated phase margin
%                                          of the PID with the current settings.
%                                          The phase margin should be greater than
%                                          45 deg and preferably greater than 65 deg
%                                          for stable conditions.
%     pidAdvisor/pmfreq            double  Output parameter. Simulated phase margin
%                                          frequency.
%     pidAdvisor/stable            int     Output parameter. When 1, the PID Advisor
%                                          found a stable solution with the given
%                                          settings. When 0, revise your settings
%                                          and rerun the PID Advisor.
%     pidAdvisor/step              struct  Output parameter. Contains the resulting
%                                          step response plot of the PID simulation.
%     pidAdvisor/targetbw          double  Requested PID bandwidth. Higher
%                                          frequencies may need manual tuning.
%     pidAdvisor/targetfail        int     Output parameter. 1 indicates the
%                                          simulated PID BW is smaller than the
%                                          Target BW.
%     pidAdvisor/tf/closedloop     int     Switch the response calculation mode
%                                          between closed or open loop.
%     pidAdvisor/tf/input          int     Start point for the plant response
%                                          simulation for open or closed loops.
%     pidAdvisor/tf/output         int     End point for the plant response
%                                          simulation for open or closed loops.
%     pidAdvisor/tune              int     Optimize the PID parameters so that
%                                          the noise of the closed-loop
%                                          system gets minimized. The HF2 doesn't
%                                          support tuning.
%     pidAdvisor/tuner/mode        int     Select tuner mode. Mode value
%                                          is bit coded, bit 0: P, bit 1: I,
%                                          bit 2: D, bit 3: D filter limit.
%     pidAdvisor/tuner/averagetime double  Time for a tuner iteration.
%
%   handle = ziDAQ('pidAdvisor', timeout);
%                  timeout = Poll timeout in [ms] - DEPRECATED, ignored
%                  Creates a PID Advisor class for simulating the PID in the
%                  device. Before the thread start, set the command parameters,
%                  call execute() and then set the "calculate" parameter to start
%                  the simulation.
%
%
%% AWG Module
%
%   handle = ziDAQ('awgModule');
%                  Creates an AWG compiler class for compiling the AWG sequence and
%                  pattern downloaded to the device .
%
%   AWG Module Parameters
%
%     Path name                       Type    Description
%     awgModule/compiler/sourcefile   string  AWG sequencer program file to load.
%                                             The file needs to be saved in the 'src'
%                                             sub-directory of the AWG settings
%                                             directory.
%     awgModule/compiler/sourcestring string  AWG sequencer program string to load.
%                                             Allows to compile a sequencer program
%                                             without saving it to a file first.
%                                             Compilation will start directly after
%                                             setting of the parameter. Setting
%                                             awgModule/compiler/start is not
%                                             necessary.
%     awgModule/compiler/waveforms    string  Comma-separated list waveform files to
%                                             be used by the AWG sequencer program.
%     awgModule/compiler/statusstring string  Status message of the compiler (read
%                                             only)
%     awgModule/compiler/status       int     Status of the compiler (read only):
%                                             -1 = idle
%                                              0 = compilation successful
%                                              1 = compilation failed
%                                              2 = compilation encountered warnings
%     awgModule/compiler/start        bool    Start compilation using the source file
%                                             specified by
%                                             awgModule/compiler/sourcefile
%                                             and upload of the AWG sequencer program
%                                             to the device. Will be reset after
%                                             completion or on error.
%     awgModule/device                string  Device that should be used to run AWG
%                                             sequencer programs, e.g. 'dev99'
%     awgModule/directory             string  Directory where AWG sequencer programs,
%                                             waveforms and ELF files should be
%                                             located. If not set, the default
%                                             settings location of the LabOne
%                                             software is used.
%     awgModule/elf/file              string  File name of the ELF file to upload. If
%                                             not set, the name will be set
%                                             automatically based on the source file
%                                             name. The file will be saved in the
%                                             'elf' sub-directory of the AWG settings
%                                             directory.
%     awgModule/elf/upload            bool    Start upload of the AWG sequencer
%                                             program to the device. Will be reset
%                                             after completion or on error.
%     awgModule/elf/status            int     Status of the ELF file upload (read-
%                                             only).
%                                             -1 = idle
%                                              0 = upload successful
%                                              1 = upload failed
%                                              2 = upload is in progress
%     awgModule/elf/checksum          int     Checksum of the uploaded ELF file
%                                             (read-only).
%     awgModule/progress              double  Reports the progress of the upload with
%                                             a number between 0 and 1.
%
%
%% Impedance Module
%
%   handle = ziDAQ('impedanceModule');
%                  Creates a impedance class for executing a user compenastion.
%
%   Impedance Module Parameters
%
%     Path name                         Type    Description
%     impedanceModule/directory         string  The directory where files are saved.
%     impedanceModule/calibrate         bool    If set to true will execute a
%                                               compensation for the specified
%                                               compensation condition.
%     impedanceModule/device            string  Device string defining the device on
%                                               which the compensation is performed.
%     impedanceModule/step              int     Compensation step to be performed
%                                               when calibrate indicator is set to
%                                               true.
%                                               0 - First load
%                                               1 - Second load
%                                               2 - Third load
%                                               3 - Fourth load
%     impedanceModule/mode              int     Compensation mode to be used. Defines
%                                               which load steps need to be
%                                               compensated.
%                                               3 - SO (Short-Open)
%                                               4 - L (Load)
%                                               5 - SL (Short-Load)
%                                               6 - OL (Open-Load)
%                                               7 - SOL (Short-Open-Load)
%                                               8 - LLL (Load-Load-Load)
%     impedanceModule/status            int     Bit coded field of the already
%                                               compensated load conditions
%                                               (bit 0 = first load).
%     impedanceModule/loads/0/r         double  Resistance value of first
%                                               compensation load (SHORT) [Ohm]
%     impedanceModule/loads/1/r         double  Resistance value of second
%                                               compensation load (OPEN) [Ohm]
%     impedanceModule/loads/2/r         double  Resistance value of third
%                                               compensation load (LOAD) [Ohm]
%     impedanceModule/loads/3/r         double  Resistance value of the fourth
%                                               compensation load (LOAD) [Ohm]. This
%                                               load setting is only used if high
%                                               impedance load is enabled.
%     impedanceModule/loads/0/c         double  Parallel capacitance of the first
%                                               compensation load (SHORT) [F]
%     impedanceModule/loads/1/c         double  Parallel capacitance of the second
%                                               compensation load (OPEN) [F]
%     impedanceModule/loads/2/c         double  Parallel capacitance of the third
%                                               compensation load (LOAD) [F]
%     impedanceModule/loads/3/c         double  Parallel capacitance of the fourth
%                                               compensation load (LOAD) [F]
%     impedanceModule/freq/start        double  Start frequency of compensation
%                                               traces [Hz]
%     impedanceModule/freq/stop         double  Stop frequency of compensation traces
%                                               [Hz]
%     impedanceModule/freq/samplecount  int     Number of samples of a compensation
%                                               trace
%     impedanceModule/highimpedanceload bool    Enable a second high impedance load
%                                               compensation for the low current
%                                               ranges.
%     impedanceModule/expectedstatus    int     Bit field of the load condition that
%                                               the corresponds a full compensation.
%                                               If status is equal the expected
%                                               status the compensation is complete.
%     impedanceModule/message           string  Message string containing
%                                               information, warnings or error
%                                               messages during compensation.
%     impedanceModule/comment           string  Comment string that will be saved
%                                               together
%                                               with the compensation data.
%     impedanceModule/validation        bool    Enable the validation of compensation
%                                               data. If enabled the compensation is
%                                               checked for too big deviation from
%                                               specified load.
%     impedanceModule/precision         int     Precision of the compensation. Will
%                                               affect time of a compensation and
%                                               reduces the noise on compensation
%                                               traces.
%                                               0 - Standard speed
%                                               1 - Low speed / high precision
%     impedanceModule/todevice          bool    If enabled will automatically
%                                               transfer compensation data to the
%                                               persistent flash memory in case of a
%                                               valid compensation.
%     impedanceModule/progress          double  Progress of a compensation condition.
%
%
%% Scope Module
%
%   Scope Module Parameters
%     Path name                    Type    Description
%     scopeModule/historylength    int     Maximum number of entries stored in the
%                                          measurement history.
%     scopeModule/clearhistory     bool    Remove all records from the history list.
%     scopeModule/externalscaling  double  Scaling to apply to the scope data
%                                          transferred over API level 1 connection
%                                          (HF2).
%     scopeModule/mode             int     Scope data processing mode:
%                                          0 - Pass through: scope segments assembled
%                                              and returned unprocessed,
%                                              non-interleaved.
%                                          1 - Moving average: entire scope recording
%                                              assembled, scaling applied, averager
%                                              if enabled (see weight), data returned
%                                              in float non-interleaved format.
%                                          2 - Average: not implemented yet.
%                                          3 - FFT: same as mode 1, except FFT
%                                              applied to every segment of the scope
%                                              recording. See fft/* nodes for FFT
%                                              parameters.
%     scopeModule/averager/weight  int    =1 - averager disabled.
%                                         >1 - moving average, updating last history
%                                              entry.
%     scopeModule/averager/restart bool    1 - resets the averager. Action node,
%                                              switches back to 0 automatically.
%     scopeModule/averager/resamplingmode
%                                  int     When averaging low sampling rate data
%                                          aligned by high resolution trigger, scope
%                                          data must be resampled to keep same
%                                          samples positioning relative to the
%                                          trigger between averaged recordings.
%                                          Resample using:
%                                          0 - Liner interpolation
%                                          1 - PCHIP interpolation
%     scopeModule/fft/window       int     FFT Window:
%                                          0 - Rectangular
%                                          1 - Hann
%                                          2 - Hamming
%                                          3 - Blackman Harris 4 term
%                                          16 - Exponential (ring-down)
%                                          17 - Cosine (ring-down)
%                                          18 - Cosine squared (ring-down)
%     scopeModule/fft/power        bool    1 - Calculate power value
%     scopeModule/fft/spectraldensity
%                                  bool    1 - Calculate spectral density value
%     scopeModule/save/directory   string  The base directory where files are saved.
%     scopeModule/save/filename    string  Defines the sub-directory where
%                                          files are saved. The actual sub-directory
%                                          have this name with a sequence count
%                                          appended, e.g. zoomFFT_000.
%     scopeModule/save/fileformat  string  The format of the file for saving data:
%                                          0 = Matlab,
%                                          1 = CSV,
%                                          2 = ZView (Impedance data only).
%     scopeModule/save/csvseparator
%                                  string  The character to use as CSV separator when
%                                          saving files in this format.
%     scopeModule/save/csvlocale   string  The locale to use for the decimal point
%                                          character and digit grouping character for
%                                          numerical values in CSV files:
%                                          "C" (default)     = dot for the decimal
%                                                              point and no digit
%                                                              grouping,
%                                          "" (empty string) = use the symbols set in
%                                                              the language and
%                                                              region settings of the
%                                                              computer.
%     scopeModule/save/save        bool   Initiate the saving of data to file. The
%                                         saving is done in the background When the
%                                         save is finished, this parameter goes low.
%
%% Multi-Device Sync Module
%
%   Multi-Device Sync Module Parameters
%     Path name                      Type    Description
%     multiDeviceSyncModule/devices  string  Defines which instruments should be
%                                            included in the synchronization. Expects
%                                            a comma-separated list of devices in the
%                                            order the devices are connected.
%     multiDeviceSyncModule/group    int     Defines in which synchronization group
%                                            should be accessed by the module.
%     multiDeviceSyncModule/message  int     Status message of the module.
%     multiDeviceSyncModule/start    bool    Set to true to start the synchronization
%                                            process.
%     multiDeviceSyncModule/status   int     Status of the synchronization process.
%                                            -1 - error
%                                             0 - idle
%                                             1 - synchronization in progress
%                                             2 - synchronization successful
%    multiDeviceSyncModule/recover   bool    Set to enable recovery of already
%                                            synchronized devices.
%                                             0 - off (default)
%                                             1 - on
%    multiDeviceSyncModule/phasesync bool    Set to 1 to start phase reset on\n"
%                                            alloscillators of synches\n"
%                                            devices.")
%
%
%% Data Acquisition Module
%
%   handle = ziDAQ('dataAcquisitionModule', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the DataAcquisitionModule class.
%                  Create an instance of the Data Acquisition Module class
%                  and return a Matlab handle with which to access it.
%                  Before the thread can actually be started (via 'execute'):
%                  - the desired data to record must be specified via the module's
%                    'subscribe' command,
%                  - the device serial (e.g., dev100) that will be used must be
%                    set.
%                  The real measurement is started upon calling the 'execute'
%                  function. After that the module will start recording data and
%                  verifying for incoming triggers.
%                  Force a trigger to manually record one duration of the
%                  subscribed data.
%
%
%   Data Acquisition Module Parameters
%     dataAcquisitionModule/buffercount
%                                   int    The number of buffers used for
%                                          data acquisition (read-only).
%     dataAcquisitionModule/buffersize
%                                   double The buffersize [s] of the Data
%                                          Acquisition Module object (read-only).
%     dataAcquisitionModule/flags   int    Record flags.
%                                          FILL  = 0x0001 : Not supported by module.
%                                                           Grid mode will always
%                                                           fill data loss holes.
%                                          ALIGN = 0x0002 : Not supported by module.
%                                                           Grid Mode will always
%                                                           align data.
%                                          THROW = 0x0004 : Throw if sample loss is
%                                                           detected.
%                                          DETECT = 0x0008: Just detect data loss
%                                                           holes. This flag is
%                                                           always enabled.
%     dataAcquisitionModule/device  string The device serial to use
%                                          the Data Acquisition Module with, e.g.
%                                          dev123 (compulsory
%                                          parameter).
%     dataAcquisitionModule/enable  bool   Enable the module.
%     dataAcquisitionModule/endless bool   Enable endless triggering
%                                          1=enable; 0=disable.
%     dataAcquisitionModule/fft/absolute
%                                   bool   Shifts the frequencies so that the center
%                                          frequency becomes the demodulation
%                                          frequency rather than 0 Hz.
%     dataAcquisitionModule/fft/window
%                                   int    FFT window (default 1 = Hann)
%                                          0 = Rectangular
%                                          1 = Hann
%                                          2 = Hamming
%                                          3 = Blackman Harris 4 term
%                                          16 - Exponential (ring-down)
%                                          17 - Cosine (ring-down)
%                                          18 - Cosine squared (ring-down)
%     dataAcquisitionModule/forcetrigger
%                                   bool   Force a trigger.
%     dataAcquisitionModule/triggered
%                                   bool   Indicates a trigger event.
%     dataAcquisitionModule/awgcontrol
%                                   bool   Enable interaction with AWG. If enabled
%                                          the hwtrigger index counter will be used
%                                          to control the grid row for recording.
%     dataAcquisitionModule/triggernode
%                                   string Path and signal of the node that should be
%                                          used for triggering, separated by a
%                                          dot (.), e.g.  /devN/demods/0/sample.x
%     dataAcquisitionModule/count   int    Number of trigger edges to record.
%     dataAcquisitionModule/type    int    Trigger type used. Some parameters are
%                                          only valid for special trigger types.
%                                          0 = trigger off
%                                          1 = analog edge trigger on source
%                                          2 = digital trigger mode on DIO source
%                                          3 = analog pulse trigger on source
%                                          4 = analog tracking trigger on source
%                                          5 = change trigger
%                                          6 = hardware trigger on trigger line
%                                              source
%                                          7 = tracking edge trigger on source
%                                          8 = event count trigger on counter source
%     dataAcquisitionModule/edge    int    Trigger edge
%                                          1 = rising edge
%                                          2 = falling edge
%                                          3 = both
%     dataAcquisitionModule/findlevel
%                                   bool   Automatically find the value of
%                                          dataAcquisitionModule/level based on the
%                                          current signal value.
%     dataAcquisitionModule/bits    int    Digital trigger condition.
%     dataAcquisitionModule/bitmask
%                                   int    Bit masking for bits used for triggering.
%                                          Used for digital trigger.
%     dataAcquisitionModule/delay   double Trigger frame position [s] (left side)
%                                          relative to trigger edge.
%                                          delay = 0 -> trigger edge at left border.
%                                          delay < 0 -> trigger edge inside trigger
%                                                       frame (pretrigger).
%                                          delay > 0 -> trigger edge before trigger
%                                                       frame (posttrigger).
%     dataAcquisitionModule/duration
%                                   double Data acquisition frame length [s]
%     dataAcquisitionModule/level   double Trigger level voltage [V].
%     dataAcquisitionModule/hysteresis
%                                   double Trigger hysteresis [V].
%     dataAcquisitionModule/triggered
%                                   bool   Has the Module triggered?
%                                          1=Yes, 0=No (read only).
%     dataAcquisitionModule/bandwidth
%                                   double Filter bandwidth [Hz] for pulse and
%                                          tracking triggers.
%     dataAcquisitionModule/holdoff/count
%                                   int    Number of skipped triggers until the next
%                                          trigger is recorded again.
%     dataAcquisitionModule/holdoff/time
%                                   double Hold off time [s] before the next trigger
%                                          is acquired again. A hold off time smaller
%                                          than the duration will produce overlapped
%                                          trigger frames.
%     dataAcquisitionModule/pulse/min
%                                   double Minimum pulse width [s] for the pulse
%                                          trigger.
%     dataAcquisitionModule/pulse/max
%                                   double Maximum pulse width [s] for the pulse
%                                          trigger.
%     dataAcquisitionModule/eventcount/mode
%                                   int    Specifies the mode used for event count
%                                          processing.
%                                          0 - Trigger on every event count sample
%                                          1 - Trigger if event count value
%                                              incremented
%     dataAcquisitionModule/grid/mode
%                                   int    Specify how the captured data is mapped
%                                          onto the grid. Each trigger becomes a row
%                                          in the matrix and each trigger's data is
%                                          mapped onto a new grid row defined by the
%                                          number of columns using this setting:
%                                          1: Use nearest neighbour interpolation.
%                                          2: Use with linear interpolation.
%                                          4: Use exact alignment to the grid.
%                                             In this mode the duration is
%                                             determined from the number of grid
%                                             columns and the highest data sampling
%                                             rate of the signals to be captured.
%     dataAcquisitionModule/grid/overwrite
%                                   int    If enabled, the module will return only
%                                          one data chunk when it is running, which
%                                          is overwritten by consecutive triggers.
%     dataAcquisitionModule/grid/cols
%                                   int    Specify the number of columns in the
%                                          grid's matrix. The data from each row is
%                                          mapped onto the grid according to the
%                                          grid/mode setting with the
%                                          specified number of columns.
%     dataAcquisitionModule/grid/rows
%                                   int    Specify the number of rows in the grid's
%                                          matrix. Each row is the data recorded from
%                                          one trigger mapped onto the columns.
%     dataAcquisitionModule/grid/repetitions
%                                   int    Number of statistical operations performed
%                                          per grid.
%     dataAcquisitionModule/grid/direction
%                                   int    The direction to organize data in the
%                                          grid's matrix:
%                                          0: Forward. The data in each row is
%                                             ordered chronologically, e.g., the
%                                             first data point in each row
%                                             corresponds to the first timestamp in
%                                             the trigger data.
%                                          1: Reverse. The data in each row is
%                                             ordered reverse chronologically, e.g.,
%                                             the first data point in each row
%                                             corresponds to the last timestamp in
%                                             the trigger data.
%                                          2: Bidirectional.  The ordering of the
%                                             data alternates between Forward and
%                                             Backward ordering from row-to-row. The
%                                             first row is Forward ordered.
%     dataAcquisitionModule/grid/waterfall
%                                   int    If enabled, the last grid row is always
%                                          updated and the previously captured rows
%                                          are shifted by one.
%     dataAcquisitionModule/refreshrate
%                                   double Set the rate at which the triggers are
%                                          processed (Hz).
%     dataAcquisitionModule/save/directory
%                                   string The base directory where files are saved.
%     dataAcquisitionModule/save/filename
%                                   string Defines the sub-directory where files are
%                                          saved. The actual sub-directory has this
%                                          name with a sequence count (per save)
%                                          appended, e.g.swtrigger_000.
%     dataAcquisitionModule/save/fileformat
%                                   string The format of the file for saving data:
%                                          0 = Matlab,
%                                          1 = CSV,
%                                          2 = SXM (Image format).
%     dataAcquisitionModule/save/csvseparator
%                                   string The character to use as CSV separator when
%                                          saving files in this format.
%     dataAcquisitionModule/save/csvlocale
%                                   string The locale to use for the decimal point
%                                          character and digit grouping character for
%                                          numerical values in CSV files:
%                                          "C" (default)     = dot for the decimal
%                                                              point and no digit
%                                                              grouping,
%                                          "" (empty string) = use the symbols set
%                                                              in the language and
%                                                              region settings of the
%                                                              computer.
%     dataAcquisitionModule/save/save
%                                   bool   Initiate the saving of data to file. The
%                                          saving is done in the background. When the
%                                          save is finished, this parameter goes low.
%     dataAcquisitionModule/historylength
%                                   bool   Sets an upper limit for the number of
%                                          data captures stored in the module.
%     dataAcquisitionModule/preview bool   When enabled, allows the data of an
%                                          incomplete trigger to be read. Useful
%                                          for long data acquisitions/FFTs to
%                                          display the progress.
%
%     dataAcquisitionModule/clearhistory
%                                   bool   Clear all captured data from the module.
%
%     dataAcquisitionModule/spectrum/autobandwidth
%                                   bool   When set to 1, initiates automatic
%                                          adjustment of the demodulator bandwidths
%                                          to obtain optimal alias rejection for the
%                                          selected frequency span which is
%                                          equivalent to the sampling rate.
%                                          The FFT mode has to be enabled
%                                          (spectrum/enable) and the module has
%                                          to be running for this function
%                                          to take effect.
%
%     dataAcquisitionModule/spectrum/enable
%                                   bool   Enables the FFT mode of the data
%                                          Acquisition module, in addition to
%                                          time domain.
%
%     dataAcquisitionModule/spectrum/frequencyspan
%                                   double Sets the desired frequency span of
%                                          the FFT.
%
%     dataAcquisitionModule/spectrum/overlapped
%                                   bool   Enables overlapping FFTs. If disabled (0),
%                                          FFTs are performed on distinct abutting
%                                          data sets. If enabled, the data sets of
%                                          successive FFTs overlap based on the
%                                          defined refresh rate.
%
%
%% Debugging Functions
%
%            ziDAQ('setDebugLevel', debuglevel);
%                  debuglevel (int) = Debug level (trace:0, info:1, debug:2,
%                  warning:3, error:4, fatal:5, status:6).
%                  Enables debug log and sets the debug level.
%
%            ziDAQ('writeDebugLog', severity, message);
%                  severity (int) = Severity (trace:0, info:1, debug:2, warning:3,
%                  error:4, fatal:5, status:6).
%                  message (str) = Message to output to the log.
%                  Outputs message to the debug log (if enabled).
%
%            ziDAQ('logOn', flags, filename, [style]);
%                  flags = LOG_NONE:             0x00000000
%                          LOG_SET_DOUBLE:       0x00000001
%                          LOG_SET_INT:          0x00000002
%                          LOG_SET_BYTE:         0x00000004
%                          LOG_SET_STRING:       0x00000008
%                          LOG_SYNC_SET_DOUBLE:  0x00000010
%                          LOG_SYNC_SET_INT:     0x00000020
%                          LOG_SYNC_SET_BYTE:    0x00000040
%                          LOG_SYNC_SET_STRING:  0x00000080
%                          LOG_GET_DOUBLE:       0x00000100
%                          LOG_GET_INT:          0x00000200
%                          LOG_GET_BYTE:         0x00000400
%                          LOG_GET_STRING:       0x00000800
%                          LOG_GET_DEMOD:        0x00001000
%                          LOG_GET_DIO:          0x00002000
%                          LOG_GET_AUXIN:        0x00004000
%                          LOG_LISTNODES:        0x00010000
%                          LOG_SUBSCRIBE:        0x00020000
%                          LOG_UNSUBSCRIBE:      0x00040000
%                          LOG_GET_AS_EVENT:     0x00080000
%                          LOG_UPDATE:           0x00100000
%                          LOG_POLL_EVENT:       0x00200000
%                          LOG_POLL:             0x00400000
%                          LOG_ALL :             0xffffffff
%                  filename = Log file name
%                  [style] = LOG_STYLE_TELNET: 0 (default)
%                            LOG_STYLE_MATLAB: 1
%                            LOG_STYLE_PYTHON: 2
%                  Log all API commands sent to the Data Server. This is useful
%                  for debugging.
%
%            ziDAQ('logOff');
%                  Turn of message logging.
%
%
%% SW Trigger Module (this module will be made deprecated in a future release - new
%  users should use the DAQ Module instead).
%
%   handle = ziDAQ('record' duration, timeout);
%                  duration (double) = The module's internal buffersize to use when
%                                      recording data [s]. The recommended size is
%                                      2*trigger/0/duration parameter. Note that
%                                      this can be modified via the
%                                      trigger/buffersize parameter.
%                                      DEPRECATED, set 'buffersize' param instead.
%                  timeout (int64) = Poll timeout [ms]. - DEPRECATED, ignored
%                  Create an instance of the ziDAQRecorder class (note that
%                  the module's thread is not yet started) and return a Matlab
%                  handle with which to access it.
%                  Before the thread can actually be started (via 'execute'):
%                  - the desired data to record must be specified via the module's
%                    'subscribe' command,
%                  - the device serial (e.g., dev100) that will be used must be
%                    set.
%                  The real measurement is started upon calling the 'execute'
%                  function. After that the trigger will start recording data and
%                  verifying for incoming triggers.
%
%            ziDAQ('trigger', handle);
%                  handle = Matlab handle (reference) specifying an instance of
%                           the ziDAQRecorder class.
%                  Force a trigger to manually record one duration of the
%                  subscribed data.
%
%   Trigger Parameters
%     trigger/buffersize         double Set the buffersize [s] of the trigger
%                                       object. The recommended buffer size is
%                                       2*trigger/0/duration.
%     trigger/flags              int    Record flags.
%                                       FILL  = 0x0001 : Fill holes.
%                                       ALIGN = 0x0002 : Align data that contains a
%                                                        timestamp.
%                                       THROW = 0x0004 : Throw if sample loss
%                                                        is detected.
%                                       DETECT = 0x0008: Just detect data loss holes.
%     trigger/device             string The device serial to use the software trigger
%                                       with, e.g. dev123 (compulsory parameter).
%     trigger/endless            bool   Enable endless triggering 1=enable;
%                                       0=disable.
%     trigger/forcetrigger       bool   Force a trigger.
%     trigger/awgcontrol         bool   Enable interaction with AWG. If enabled the
%                                       hwtrigger index counter will be used to
%                                       control the grid row for recording.
%     trigger/0/triggernode      string Path and signal of the node that should be
%                                       used for triggering, separated by a dot (.),
%                                       e.g. /devN/demods/0/sample.x
%                                       Overrides values from trigger/0/path and
%                                       trigger/0/source.
%     trigger/0/path             string The path to the demod sample to trigger on,
%                                       e.g. demods/3/sample, see also
%                                       trigger/0/source
%                                       DEPRECATED - use trigger/0/triggernode
%                                       instead
%     trigger/0/source           int    Signal that is used to trigger on.
%                                       0 = x
%                                       1 = y
%                                       2 = r
%                                       3 = angle
%                                       4 = frequency
%                                       5 = phase
%                                       6 = auxiliary input 0 / parameter 0
%                                       7 = auxiliary input 1 / parameter 1
%                                       DEPRECATED - use trigger/0/triggernode
%                                       instead
%     trigger/0/count            int    Number of trigger edges to record.
%     trigger/0/type             int    Trigger type used. Some parameters are
%                                       only valid for special trigger types.
%                                       0 = trigger off
%                                       1 = analog edge trigger on source
%                                       2 = digital trigger mode on DIO source
%                                       3 = analog pulse trigger on source
%                                       4 = analog tracking trigger on source
%                                       5 = change trigger
%                                       6 = hardware trigger on trigger line
%                                           source
%                                       7 = tracking edge trigger on source
%                                       8 = event count trigger on counter source
%     trigger/0/edge             int    Trigger edge
%                                       1 = rising edge
%                                       2 = falling edge
%                                       3 = both
%     trigger/0/findlevel        bool   Automatically find the value of
%                                       trigger/0/level
%                                       based on the current signal value.
%     trigger/0/bits             int    Digital trigger condition.
%     trigger/0/bitmask          int    Bit masking for bits used for
%                                       triggering. Used for digital trigger.
%     trigger/0/delay            double Trigger frame position [s] (left side)
%                                       relative to trigger edge.
%                                       delay = 0 -> trigger edge at left border.
%                                       delay < 0 -> trigger edge inside trigger
%                                                    frame (pretrigger).
%                                       delay > 0 -> trigger edge before trigger
%                                                    frame (posttrigger).
%     trigger/0/duration         double Recording frame length [s]
%     trigger/0/level            double Trigger level voltage [V].
%     trigger/0/hysteresis       double Trigger hysteresis [V].
%     trigger/0/retrigger        int    Record more than one trigger in a trigger
%                                       frame. If a trigger event is currently being
%                                       recorded and another trigger event is
%                                       detected within the duration of the current
%                                       trigger event, extend the size of the
%                                       trigger frame to include the duration of the
%                                       new trigger event.
%     trigger/triggered          bool   Has the software trigger triggered? 1=Yes,
%                                       0=No (read only).
%     trigger/0/bandwidth        double Filter bandwidth [Hz] for pulse and
%                                       tracking triggers.
%     trigger/0/holdoff/count    int    Number of skipped triggers until the
%                                       next trigger is recorded again.
%     trigger/0/holdoff/time     double Hold off time [s] before the next
%                                       trigger is recorded again. A hold off
%                                       time smaller than the duration will
%                                       produce overlapped trigger frames.
%     trigger/0/hwtrigsource     int    Only available for devices that support
%                                       hardware triggering. Specify the channel
%                                       to trigger on.
%                                       DEPRECATED - use trigger/0/triggernode
%                                       instead
%     trigger/0/pulse/min        double Minimal pulse width [s] for the pulse
%                                       trigger.
%     trigger/0/pulse/max        double Maximal pulse width [s] for the pulse
%                                       trigger.
%     trigger/0/eventcount/mode  int    Specifies the mode used for event count
%                                       processing.
%                                       0 - Trigger on every event count sample
%                                       1 - Trigger if event count value incremented
%     trigger/0/grid/mode        int    Enable grid mode. In grid mode a matrix
%                                       instead of a vector is returned. Each
%                                       trigger becomes a row in the matrix and each
%                                       trigger's data is interpolated onto a new
%                                       grid defined by the number of columns:
%                                       0: Disable
%                                       1: Enable with nearest neighbour
%                                          interpolation
%                                       2: Enable with linear interpolation.
%     trigger/0/grid/operation   int    If running in endless mode, either replace
%                                       or average the data in the grid's matrix.
%     trigger/0/grid/cols        int    Specify the number of columns in the grid's
%                                       matrix. The data from each row is
%                                       interpolated onto a grid with the specified
%                                       number of columns.
%     trigger/0/grid/rows        int    Specify the number of rows in the grid's
%                                       matrix. Each row is the data recorded from
%                                       one trigger interpolated onto the columns.
%     trigger/0/grid/repetitions int    Number of statistical operations performed
%                                       per grid.
%     trigger/0/grid/direction   int    The direction to organize data in the grid's
%                                       matrix:
%                                       0: Forward.
%                                          The data in each row is ordered chrono-
%                                          logically, e.g., the first data point in
%                                          each row corresponds to the first
%                                          timestamp in the trigger data.
%                                       1: Reverse.
%                                          The data in each row is ordered reverse
%                                          chronologically, e.g., the first data
%                                          point in each row corresponds to the last
%                                          timestamp in the trigger data.
%                                       2: Bidirectional.
%                                          The ordering of the data alternates
%                                          between Forward and Backward ordering from
%                                          row-to-row. The first row is Forward
%                                          ordered.
%     trigger/save/directory     string The base directory where files are saved.
%     trigger/save/filename      string Defines the sub-directory where files
%                                       are saved. The actual sub-directory
%                                       have this name with a sequence count
%                                       appended, e.g. swtrigger_000.
%     trigger/save/fileformat    string The format of the file for saving data:
%                                       0 = Matlab,
%                                       1 = CSV,
%                                       2 = ZView (Impedance data only).
%     trigger/save/csvseparator  string The character to use as CSV separator when
%                                       saving files in this format.
%     trigger/save/csvlocale     string The locale to use for the decimal point
%                                       character and digit grouping character
%                                       for numerical values in CSV files:
%                                       "C" (default)     = dot for the decimal
%                                                           point and no digit
%                                                           grouping,
%                                       "" (empty string) = use the symbols
%                                                           set in the language
%                                                           and region settings
%                                                           of the computer.
%     trigger/save/save          bool   Initiate the saving of data to file.
%                                       The saving is done in the background
%                                       When the save is finished, this
%                                       parameter goes low.
%     trigger/historylength      bool   Maximum number of entries stored in the
%                                       measurement history.
%     trigger/clearhistory       bool   Remove all records from the history list.
%
%
%% Spectrum Module (this module will be made deprecated in a future release - new
%  users should use the DAQ Module instead).
%
%   handle = ziDAQ('zoomFFT', timeout);
%                  timeout = Poll timeout in [ms] - DEPRECATED, ignored
%                  Creates a zoom FFT class. The thread is not yet started.
%                  Before the thread start subscribe and set command have
%                  to be called. To start the real measurement use the
%                  execute function.
%
%   Zoom FFT Parameters (brief description, see the Programming Manual for more
%   information)
%     zoomFFT/device        string  Device that should be used for
%                                   the FFT, e.g. 'dev99'.
%     zoomFFT/bit           int     Number of FFT points 2^bit
%     zoomFFT/mode          int     Signal source for the FFT.
%                                   0 = Perform FFT on X+iY
%                                   1 = Perform FFT on R
%                                   2 = Perform FFT on Phase
%                                   3 = Perform FFT on Frequency
%                                   4 = Perform FFT on Phase derivative
%     zoomFFT/loopcount     int     Number of zoom FFT loops (default 1)
%     zoomFFT/endless       int     Run the frequency analysis continuously
%                                   (default 0)
%                                   0 = endless off, use loopcount value
%                                   1 = endless on, ignore loopcount
%     zoomFFT/overlap       double  Overlap of the demod data used
%                                   for the FFT,  0 = none, [0..1]
%     zoomFFT/settling/time double  Settling time before measurement is performed
%     zoomFFT/settling/tc   double  Settling time in time constant units before
%                                   the FFT recording is started.
%                                   5 ~ low precision
%                                   15 ~ medium precision
%                                   50 ~ high precision
%     zoomFFT/window        int     FFT window (default 1 = Hann)
%                                   0 = Rectangular
%                                   1 = Hann
%                                   2 = Hamming
%                                   3 = Blackman Harris 4 term
%                                   16 - Exponential (ring-down)
%                                   17 - Cosine (ring-down)
%                                   18 - Cosine squared (ring-down)
%     zoomFFT/absolute      bool    Shifts the frequencies so that the center
%                                   frequency becomes the demodulation frequency
%                                   rather than 0 Hz.
%     zoomFFT/save/directory
%                           string  The base directory where files are saved.
%     zoomFFT/save/filename string  Defines the sub-directory where files are
%                                   saved. The actual sub-directory have this
%                                   name with a sequence count appended, e.g.
%                                   zoomFFT_000.
%     zoomFFT/save/fileformat
%                           string  The format of the file for saving data:
%                                   0 = Matlab,
%                                   1 = CSV,
%                                   2 = ZView (Impedance data only).
%     zoomFFT/save/csvseparator
%                           string  The character to use as CSV separator when
%                                   saving files in this format.
%     zoomFFT/save/csvlocale
%                           string  The locale to use for the decimal point
%                                   character and digit grouping character for
%                                   numerical values in CSV files:
%                                   "C" (default)     = dot for the decimal
%                                                       point and no digit
%                                                       grouping,
%                                   "" (empty string) = use the symbols set in
%                                                       the language and region
%                                                       settings of the
%                                                       computer.
%     zoomFFT/save/save      bool   Initiate the saving of data to file. The
%                                   saving is done in the background When the
%                                   save is finished, this parameter goes low.
%
