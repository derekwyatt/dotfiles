-------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------
hs.window.animationDuration = 0


-------------------------------------------------------------------
-- ControlEscape
-------------------------------------------------------------------
hs.loadSpoon('ControlEscape'):start()

-------------------------------------------------------------------
-- Vim Mode
-------------------------------------------------------------------

vim = hs.loadSpoon('VimMode')

hs.hotkey.bind({'ctrl'}, ';', function()
  vim:enter()
end)

-------------------------------------------------------------------
-- Window Layouts
-------------------------------------------------------------------

units = {
  right30       = { x = 0.7, y = 0.0, w = 0.3, h = 1.0 },
  right70       = { x = 0.3, y = 0.0, w = 0.7, h = 1.0 },
  left70        = { x = 0.0, y = 0.0, w = 0.7, h = 1.0 },
  left30        = { x = 0.0, y = 0.0, w = 0.3, h = 1.0 },
  top50         = { x = 0.0, y = 0.0, w = 1.0, h = 0.5 },
  bot50         = { x = 0.0, y = 0.5, w = 1.0, h = 0.5 },
  bot80         = { x = 0.0, y = 0.2, w = 1.0, h = 0.8 },
  upright30     = { x = 0.7, y = 0.0, w = 0.3, h = 0.5 },
  botright30    = { x = 0.7, y = 0.5, w = 0.3, h = 0.5 },
  upleft70      = { x = 0.0, y = 0.0, w = 0.7, h = 0.5 },
  botleft70     = { x = 0.0, y = 0.5, w = 0.7, h = 0.5 },
  right70top80  = { x = 0.7, y = 0.0, w = 0.3, h = 0.8 },
  maximum       = { x = 0.0, y = 0.0, w = 1.0, h = 1.0 },
  center        = { x = 0.2, y = 0.1, w = 0.6, h = 0.8 }
}

layouts = {
  alternatecoding = {
    { name = 'Firefox', unit = units.left70 },
    { name = 'VimR',    unit = units.left30 },
    { name = 'iTerm2',  unit = units.right70 }
  },
  work = {
    { name = 'Firefox',           unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'VimR',              unit = units.left30,  screen = 'Thunderbolt Display' },
    { name = 'iTerm2',            unit = units.right70, screen = 'Thunderbolt Display' },
    { name = 'Slack',             unit = units.bot80,   screen = 'Color LCD' },
    { name = 'Microsoft Outlook', unit = units.maximum, screen = 'Color LCD' },
    { name = 'WhatsApp',          unit = units.center,  screen = 'Color LCD' }
  },
  coding = {
    { name = 'Firefox', unit = units.left70 },
    { name = 'VimR',    unit = units.left70 },
    { name = 'iTerm2',  unit = units.right30 }
  },
  work = {
    { name = 'Firefox',           unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'VimR',              unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'iTerm2',            unit = units.right30, screen = 'Thunderbolt Display' },
    { name = 'Slack',             unit = units.bot80,   screen = 'Color LCD' },
    { name = 'Microsoft Outlook', unit = units.maximum, screen = 'Color LCD' },
    { name = 'WhatsApp',          unit = units.center,  screen = 'Color LCD' }
  },
  writing = {
    { name = 'Firefox', unit = units.left70 },
    { name = 'VimR',    unit = units.left70 },
    { name = 'iTerm2',  unit = units.right30 },
    { name = 'Skim',    unit = units.right70top80 }
  }
}

function isWorkMachine()
  local allNames = hs.host.names()
  for i=1,#allNames do
    if allNames[i]:match('^cawl') then
      return true
    end
  end
  return false
end


function runLayout(layout)
  for i = 1,#layout do
    local t = layout[i]
    local win = hs.application.get(t.name):mainWindow()
    local screen = nil
    if t.screen ~= nil then
      screen = hs.screen.find(t.screen)
    end
    win:move(t.unit, screen, true)
  end
end

mash = { 'shift', 'ctrl', 'cmd' }
hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right30,    nil, true) end)
hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left70,     nil, true) end)
hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.upright30,  nil, true) end)
hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(units.upleft70,   nil, true) end)
hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.botleft70,  nil, true) end)
hs.hotkey.bind(mash, "'", function() hs.window.focusedWindow():move(units.botright30, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum, nil, true) end)

if isWorkMachine() then
  hs.hotkey.bind(mash, '0', function() runLayout(layouts.work) end)
  hs.hotkey.bind(mash, '9', function() runLayout(layouts.alternatework) end)
else
  hs.hotkey.bind(mash, '0', function() runLayout(layouts.coding) end)
  hs.hotkey.bind(mash, '9', function() runLayout(layouts.alternatecoding) end)
end
hs.hotkey.bind(mash, '8', function() runLayout(layouts.writing) end)

-------------------------------------------------------------------
-- Launcher
-------------------------------------------------------------------

local appLauncherAlertWindow = nil
local launchMode = hs.hotkey.modal.new({}, nil, '')

function leaveMode()
  if appLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(appLauncherAlertWindow, 0.02)
    appLauncherAlertWindow = nil
  end
  launchMode:exit()
end

function switchToApp(app)
  hs.application.open(app)
  leaveMode()
end

hs.hotkey.bind({ 'ctrl' }, 'space', function()
  launchMode:enter()
  appLauncherAlertWindow = hs.alert.show('App Launcher Mode', {
    strokeColor = hs.drawing.color.x11.orangered,
    fillColor = hs.drawing.color.x11.cyan,
    textColor = hs.drawing.color.x11.black,
    strokeWidth = 20,
    radius = 30,
    textSize = 128,
    fadeInDuration = 0.02
  }, 'infinite')
end)
launchMode:bind({ 'ctrl' }, 'space', function() leaveMode() end)

-- Mapped keys
launchMode:bind({}, 'c',  function() switchToApp('Google Chrome.app') end)
launchMode:bind({}, 'f',  function() switchToApp('Firefox.app') end)
launchMode:bind({}, 'k',  function() switchToApp('Skim.app') end)
launchMode:bind({}, 'l',  function() switchToApp('VLC.app') end)
launchMode:bind({}, 'o',  function() switchToApp('Microsoft Outlook.app') end)
launchMode:bind({}, 's',  function() switchToApp('Slack.app') end)
launchMode:bind({}, 't',  function() switchToApp('iTerm.app') end)
launchMode:bind({}, 'v',  function() switchToApp('VimR.app') end)
launchMode:bind({}, 'w',  function() switchToApp('WhatsApp.app') end)

-- Unmapped keys
launchMode:bind({}, 'a',  function() leaveMode() end)
launchMode:bind({}, 'b',  function() leaveMode() end)

launchMode:bind({}, 'd',  function() leaveMode() end)
launchMode:bind({}, 'e',  function() leaveMode() end)

launchMode:bind({}, 'g',  function() leaveMode() end)
launchMode:bind({}, 'h',  function() leaveMode() end)
launchMode:bind({}, 'i',  function() leaveMode() end)
launchMode:bind({}, 'j',  function() leaveMode() end)


launchMode:bind({}, 'm',  function() leaveMode() end)
launchMode:bind({}, 'n',  function() leaveMode() end)

launchMode:bind({}, 'p',  function() leaveMode() end)
launchMode:bind({}, 'q',  function() leaveMode() end)
launchMode:bind({}, 'r',  function() leaveMode() end)


launchMode:bind({}, 'u',  function() leaveMode() end)


launchMode:bind({}, 'x',  function() leaveMode() end)
launchMode:bind({}, 'y',  function() leaveMode() end)
launchMode:bind({}, 'z',  function() leaveMode() end)
launchMode:bind({}, '1',  function() leaveMode() end)
launchMode:bind({}, '2',  function() leaveMode() end)
launchMode:bind({}, '3',  function() leaveMode() end)
launchMode:bind({}, '4',  function() leaveMode() end)
launchMode:bind({}, '5',  function() leaveMode() end)
launchMode:bind({}, '6',  function() leaveMode() end)
launchMode:bind({}, '7',  function() leaveMode() end)
launchMode:bind({}, '8',  function() leaveMode() end)
launchMode:bind({}, '9',  function() leaveMode() end)
launchMode:bind({}, '0',  function() leaveMode() end)
launchMode:bind({}, '-',  function() leaveMode() end)
launchMode:bind({}, '=',  function() leaveMode() end)
launchMode:bind({}, '[',  function() leaveMode() end)
launchMode:bind({}, ']',  function() leaveMode() end)
launchMode:bind({}, '\\', function() leaveMode() end)
launchMode:bind({}, ';',  function() leaveMode() end)
launchMode:bind({}, "'",  function() leaveMode() end)
launchMode:bind({}, ',',  function() leaveMode() end)
launchMode:bind({}, '.',  function() leaveMode() end)
launchMode:bind({}, '/',  function() leaveMode() end)
launchMode:bind({}, '`',  function() leaveMode() end)
