% ziDAQ : The LabOne Matlab API for interfacing with Zurich Instruments Devices
%
% FILES
%   ziAddPath  - add the LabOne Matlab API drivers, utilities and examples to
%                Matlab's Search Path for the current session
%   README.txt - a README briefly describing how to get started with ziDAQ
%
% DIRECTORIES
%   Driver/    - contains Matlab driver for interfacing with Zurich Instruments
%                devices
%   Utils/     - contains some utility functions for common tasks
%   Examples/  - contains examples for performing measurements on Zurich
%                Instruments devices
%
% DRIVER
%   Driver/ziDAQ.m          - ziDAQ command reference documentation.
%   Driver/ziDAQ.mex*       - ziDAQ API driver
%
% UTILS
%   ziAPIServerVersionCheck - check the versions of API and Data Server match
%   ziAutoConnect      - Create a connection to a Zurich Instruments
%                        server (Deprecated: See ziCreateAPISession).
%   ziAutoDetect       - Return the ID of a connected device (if only one
%                        device is connected)
%   ziBW2TC            - Convert demodulator 3dB bandwidth to timeconstant
%   ziCheckPathInData  - Check whether a node is present in data and non-empty
%   ziCreateAPISession - Create an API session for the specified device with
%                        the correct Data Server.
%   ziDevices          - Return a cell array of connected Zurich Instruments
%                        devices
%   ziDisableEverything - Disable all functional units and streaming nodes
%   ziGetDefaultSettingsPath - Get the default settings file path from the
%                        ziDeviceSettings ziCore module
%   ziGetDefaultSigoutMixerChannel - return the default output mixer channel
%   ziLoadSettings     - Load instrument settings from file
%   ziSaveSettings     - Save instrument settings to file
%   ziSiginAutorange   - Activate the device's autorange functionality
%   ziSystemtime2Matlabtime - Convert the LabOne system time to Matlab time
%   ziTC2BW            - Convert demodulator timeconstants to 3 dB Bandwidth
%
% EXAMPLES/COMMON - Examples that will run on most Zurich Instruments Devices
%   example_connect                     - A simple example to demonstrate how to
%                                         connect to a Zurich Instruments device
%   example_connect_config              - Connect to and configure a Zurich
%                                         Instruments device
%   example_save_device_settings_simple - Save and load device settings
%                                         synchronously using ziDAQ's utility
%                                         functions
%   example_save_device_settings_expert - Save and load device settings
%                                         asynchronously with ziDAQ's
%                                         devicesettings module
%   example_data_acquisition_continuous - Record data continuously using the
%                                         DAQ Module
%   example_data_acquisition_edge       - Record bursts of demodulator data upon
%                                         a rising edge using the DAQ Module
%   example_data_acquisition_fft        - Record the FFT of demodulator data
%                                         using the DAQ Module
%   example_data_acquisition_grid       - Record bursts of demodulator data
%                                         and align the data in a 2D array.
%   example_data_acquisition_grid_average - Record bursts of demodulator data
%                                         and align and average the data
%                                         row-wise in a 2D array.
%   example_sweeper                     - Perform a frequency sweep using ziDAQ's
%                                         sweep module
%   example_sweeper_rstddev_fixedbw     - Perform a frequency sweep plotting the
%                                         stddev in demodulator output R using
%                                         ziDAQ's sweep module
%   example_sweeper_two_demods          - Perform a frequency sweep saving data
%                                         from 2 demodulators using ziDAQ's sweep
%                                         module
%   example_poll                        - Record demodulator data using
%                                         ziDAQServer's synchronous poll function
%   example_poll_impedance              - Record impedance data using
%                                         ziDAQServer's synchronous poll function
%   example_scope                       - Record scope data using ziDAQServer's
%                                         synchronous poll function
%   example_pid_advisor_pll             - Setup and optimize a PID for internal
%                                         PLL mode
%   example_autoranging_impedance       - Demonstrate how to perform a manually
%                                         triggered autoranging for impedance
%                                         while working in manual range mode
%   example_multidevice_data_acquisition - Acquire data from 2 synchronized
%                                         devices using the DAQ Module
%   example_multidevice_sweep           - Perform a sweep on 2 synchronized
%                                         devices using the Sweeper Module
%
% EXAMPLES/HDAWG - Examples specific to the HDAWG Series
%   hdaqg_example_awg                   - demonstrate different methods to
%                                         create waveforms and compile and
%                                         upload a SEQC program to the AWG
%
% EXAMPLES/HF2 - Examples specific to the HF2 Series
%   hf2_example_autorange             - determine and set an appropriate range
%                                       for a sigin channel
%   hf2_example_poll_hardware_trigger - Poll demodulator data in combination
%                                       with a HW trigger
%   hf2_example_scope                 - Record scope data using ziDAQServer's
%                                       synchronous poll function
%   hf2_example_zsync_poll            - Synchronous demodulator sample timestamps
%                                       from multiple HF2s via the Zsync feature
%   hf2_example_pid_advisor_pll       - Setup and optimize a PLL using the PID
%                                       Advisor
%
% EXAMPLES/UHF - Examples specific to the UHF Series
%   uhf_example_awg                     - demonstrate different methods to
%                                         create waveforms and compile and
%                                         upload a SEQC program to the AWG
%   uhf_example_awg_sourcefile          - demonstrate how to compile/upload a
%                                         SEQC from file.
%   uhf_example_boxcar                  - Record boxcar data using ziDAQServer's
%                                         synchronous poll function
%
%
% EXAMPLES/DEPRECATED - Examples that use functionality that either is or will
%                       be made deprecated in a future release
%   example_spectrum                    - Perform an FFT using ziDAQ's zoomFFT
%                                         module (Spectrum Tab of the LabOne UI)
%   example_swtrigger_edge              - Record demodulator data upon a rising
%                                         edge trigger via ziDAQ's SW Trigger
%                                         module
%   example_swtrigger_digital           - Record data using a digital trigger via
%                                         ziDAQ's SW Trigger module
%   example_swtrigger_grid              - Record demodulator data, interpolated
%                                         on a grid from multiple triggers
%                                         using the SW Trigger's Grid Mode.
%   example_swtrigger_grid_average      - Record demodulator data, interpolated
%                                         on a grid from multiple triggers
%                                         using the SW Trigger's
%                                         Grid Mode. This example additionally
%                                         demonstrates Grid Mode's averaging
%                                         functionality.
