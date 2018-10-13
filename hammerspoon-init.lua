hs.alert.defaultStyle.strokeColor = hs.drawing.color.x11.orangered
hs.alert.defaultStyle.fillColor = hs.drawing.color.x11.cyan
hs.alert.defaultStyle.textColor = hs.drawing.color.x11.black
hs.alert.defaultStyle.strokeWidth = 20
hs.alert.defaultStyle.radius = 30
hs.alert.defaultStyle.textSize = 128
hs.alert.defaultStyle.fadeInDuration = 0.05
hs.alert.defaultStyle.fadeOutDuration = 0.05

local launchMode = hs.hotkey.modal.new({}, nil, '')

function leaveMode()
  hs.alert.closeAll()
  launchMode:exit()
end

function switchToApp(app)
  hs.application.open(app)
  leaveMode()
end

hs.hotkey.bind({ 'ctrl' }, 'space', function()
  launchMode:enter()
  hs.alert.show('App Launcher Mode', 'infinite')
end)
launchMode:bind({ 'ctrl' }, 'space', function()
  hs.alert.closeAll()
  launchMode:exit()
end)

launchMode:bind({}, 'f', function() switchToApp('Firefox.app') end)
launchMode:bind({}, 'k', function() switchToApp('Skim.app') end)
launchMode:bind({}, 'l', function() switchToApp('VLC.app') end)
launchMode:bind({}, 't', function() switchToApp('iTerm.app') end)
launchMode:bind({}, 'v', function() switchToApp('VimR.app') end)
launchMode:bind({}, 'w', function() switchToApp('WhatsApp.app') end)

launchMode:bind({}, 'a', function() leaveMode() end)
launchMode:bind({}, 'b', function() leaveMode() end)
launchMode:bind({}, 'c', function() leaveMode() end)
launchMode:bind({}, 'd', function() leaveMode() end)
launchMode:bind({}, 'e', function() leaveMode() end)

launchMode:bind({}, 'g', function() leaveMode() end)
launchMode:bind({}, 'h', function() leaveMode() end)
launchMode:bind({}, 'i', function() leaveMode() end)
launchMode:bind({}, 'j', function() leaveMode() end)


launchMode:bind({}, 'm', function() leaveMode() end)
launchMode:bind({}, 'n', function() leaveMode() end)
launchMode:bind({}, 'o', function() leaveMode() end)
launchMode:bind({}, 'p', function() leaveMode() end)
launchMode:bind({}, 'q', function() leaveMode() end)
launchMode:bind({}, 'r', function() leaveMode() end)
launchMode:bind({}, 's', function() leaveMode() end)

launchMode:bind({}, 'u', function() leaveMode() end)


launchMode:bind({}, 'x', function() leaveMode() end)
launchMode:bind({}, 'y', function() leaveMode() end)
launchMode:bind({}, 'z', function() leaveMode() end)
launchMode:bind({}, '1', function() leaveMode() end)
launchMode:bind({}, '2', function() leaveMode() end)
launchMode:bind({}, '3', function() leaveMode() end)
launchMode:bind({}, '4', function() leaveMode() end)
launchMode:bind({}, '5', function() leaveMode() end)
launchMode:bind({}, '6', function() leaveMode() end)
launchMode:bind({}, '7', function() leaveMode() end)
launchMode:bind({}, '8', function() leaveMode() end)
launchMode:bind({}, '9', function() leaveMode() end)
launchMode:bind({}, '0', function() leaveMode() end)
launchMode:bind({}, '-', function() leaveMode() end)
launchMode:bind({}, '=', function() leaveMode() end)
launchMode:bind({}, '[', function() leaveMode() end)
launchMode:bind({}, ']', function() leaveMode() end)
launchMode:bind({}, '\\', function() leaveMode() end)
launchMode:bind({}, ';', function() leaveMode() end)
launchMode:bind({}, '\'', function() leaveMode() end)
launchMode:bind({}, ',', function() leaveMode() end)
launchMode:bind({}, '.', function() leaveMode() end)
launchMode:bind({}, '/', function() leaveMode() end)
launchMode:bind({}, '`', function() leaveMode() end)
