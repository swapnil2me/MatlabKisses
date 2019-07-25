function settings = ziDisableEverything(device)
% ZIDISABLEEVERYTHING disable device streaming nodes and functionality
%
% settings = ZIDISABLEEVERYTHING(DEVICE)
%
%   Put the device in a known base configuration: disable all extended
%   functionality; disable all streaming nodes. A cell array of (set-function,
%   node, value) triples containing the settings that were configured are
%   returned.
%
% device = 'dev123';
% settings = ziDisableEverything(device);
% for i = 1:length(settings);
%     fprintf('settings{%d}: %s on %s to %d.\n', i, settings{i}{:});
% end
%
% Warning: This function is intended as a helper function for the API's
% examples and it's signature or implementation may change in
% future releases.
%
% Copyright 2008-2018 Zurich Instruments AG

branches = ziDAQ('listNodes', ['/' device ], 0);
settings = {};
if (length(branches) == 1) && strcmp(branches{1}, '')
    fprintf('Device %s is not connected to the data server.\n', device);
end

% Create a cell array.
if any(strcmp([branches], 'AUCARTS'))
    settings{end+1} = {'setInt', ['/' device '/aucarts/*/enable'], 0};
end
if any(strcmp([branches], 'AUPOLARS'))
    settings{end+1} = {'setInt', ['/' device '/aupolars/*/enable'], 0};
end
if any(strcmp([branches], 'AWGS'))
    settings{end+1} = {'setInt', ['/' device '/awgs/*/enable'], 0};
end
if any(strcmp([branches], 'BOXCARS'))
    settings{end+1} = {'setInt', ['/' device '/boxcars/*/enable'], 0};
end
currin_leaves = ziDAQ('listNodes', ['/', device, '/currins/0/'], 0);
if any(strcmp(currin_leaves, 'FLOAT'))
    settings{end+1} = {'setInt', ['/' device '/currins/*/float'], 0};
end
if any(strcmp([branches], 'CNTS'))
    settings{end+1} = {'setInt', ['/' device '/cnts/*/enable'], 0};
end
if any(strcmp([branches], 'DIOS'))
    settings{end+1} = {'setInt', ['/' device '/dios/*/drive'], 0};
end
if any(strcmp([branches], 'DEMODS'))
    settings{end+1} = {'setInt', ['/' device '/demods/*/enable'], 0};
    settings{end+1} = {'setInt', ['/' device '/demods/*/trigger'], 0};
    settings{end+1} = {'setInt', ['/' device '/demods/*/sinc'], 0};
    settings{end+1} = {'setInt', ['/' device '/demods/*/oscselect'], 0};
    settings{end+1} = {'setInt', ['/' device '/demods/*/harmonic'], 1};
    settings{end+1} = {'setInt', ['/' device '/demods/*/phaseshift'], 0};
end
if any(strcmp([branches], 'EXTREFS'))
    settings{end+1} = {'setInt', ['/' device '/extrefs/*/enable'], 0};
end
if any(strcmp([branches], 'IMPS'))
    settings{end+1} = {'setInt', ['/' device '/imps/*/enable'], 0};
end
if any(strcmp([branches], 'INPUTPWAS'))
    settings{end+1} = {'setInt', ['/' device '/inputpwas/*/enable'], 0};
end
mod_leaves = ziDAQ('listNodes', ['/', device, '/mods/0/'], 0);
if any(strcmp(mod_leaves, 'ENABLE'))
    % HF2 without the MOD Option has an empty MODS branch.
    settings{end+1} = {'setInt', ['/' device '/mods/*/enable'], 0};
end
if any(strcmp([branches], 'OUTPUTPWAS'))
    settings{end+1} = {'setInt', ['/' device '/outputpwas/*/enable'], 0};
end
pid_leaves = ziDAQ('listNodes', ['/', device, '/pids/0/enable'], 0);
if any(strcmp(pid_leaves, 'ENABLE'))
    settings{end+1} = {'setInt', ['/' device '/pids/*/enable'], 0};
end
pll_leaves = ziDAQ('listNodes', ['/', device, '/plls/0/enable'], 0);
if any(strcmp(pll_leaves, 'ENABLE'))
    % HF2 without the PLL Option still has the PLLS branch.
    settings{end+1} = {'setInt', ['/' device '/plls/*/enable'], 0};
end
if any(strcmp([branches], 'SIGINS'))
    settings{end+1} = {'setInt', ['/' device '/sigins/*/ac'], 0};
    settings{end+1} = {'setInt', ['/' device '/sigins/*/imp50'], 0};
    sigins_leaves = ziDAQ('listNodes', ['/', device, '/sigins/0/'], 0);
    if any(strcmp(sigins_leaves, 'DIFF'))
        settings{end+1} = {'setInt', ['/' device '/sigins/*/diff'], 0};
    end
    if any(strcmp(sigins_leaves, 'FLOAT'))
        settings{end+1} = {'setInt', ['/' device '/sigins/*/float'], 0};
    end
end
if any(strcmp([branches], 'SIGOUTS'))
    settings{end+1} = {'setInt', ['/' device '/sigouts/*/on'], 0};
    settings{end+1} = {'setInt', ['/' device '/sigouts/*/enables/*'], 0};
    settings{end+1} = {'setDouble', ['/' device '/sigouts/*/offset'], 0.};
    sigouts_leaves = ziDAQ('listNodes', ['/', device, '/sigouts/0/'], 0);
    if any(strcmp(sigouts_leaves, 'IMP50'))
        settings{end+1} = {'setInt', ['/' device '/sigouts/*/imp50'], 0};
    end
    if any(strcmp(sigouts_leaves, 'ADD'))
        settings{end+1} = {'setInt', ['/' device '/sigouts/*/add'], 0};
    end
    if any(strcmp(sigouts_leaves, 'DIFF'))
        settings{end+1} = {'setInt', ['/' device '/sigouts/*/diff'], 0};
    end
end
if any(strcmp([branches], 'SCOPES'))
    settings{end+1} = {'setInt', ['/' device '/scopes/*/enable'], 0};
    scope_segment_leaves = ziDAQ('listNodes', ['/', device, '/scopes/0/segments/'], 0);
    if any(strcmp(scope_segment_leaves, 'enable'))
        settings{end+1} = {'setInt', ['/' device '/scopes/*/segments/enable'], 0};
    end
    scope_stream_leaves = ziDAQ('listNodes', ['/', device, '/scopes/0/stream/enables'], 0);
    if any(strcmp(scope_stream_leaves, '0'))
        settings{end+1} = {'setInt', ['/' device '/scopes/*/stream/enables/*'], 0};
    end
end
triggers_out_leaves = ziDAQ('listNodes', ['/', device, '/triggers/out/0/drive'], 0);
if any(strcmp(triggers_out_leaves, 'TRIGGERS'))
    settings{end+1} = {'setInt', ['/' device '/triggers/out/*/drive'], 0};
end

% Perform a global synchronisation between the device and the data server
for ii=1:length(settings)
    ziDAQ(settings{ii}{1}, settings{ii}{2}, settings{ii}{3});
end
ziDAQ('sync');

end
