function DAQclcChn(s)
for i=1:length(s.Channels)
    s.removeChannel(1)
end
end