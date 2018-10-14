-------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------
hs.window.animationDuration = 0

-------------------------------------------------------------------
-- Vim Mode
-------------------------------------------------------------------

vim = hs.loadSpoon('VimMode')

-- Basic key binding to ctrl+;
-- You can choose any key binding you want here, see:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind

hs.hotkey.bind({'ctrl'}, ';', function()
  vim:enter()
end)

-------------------------------------------------------------------
-- Window Layouts
-------------------------------------------------------------------

units = {
  right30    = { x = 0.7, y = 0.0, w = 0.3, h = 1.0 },
  left70     = { x = 0.0, y = 0.0, w = 0.7, h = 1.0 },
  top50      = { x = 0.0, y = 0.0, w = 1.0, h = 0.5 },
  bot50      = { x = 0.0, y = 0.5, w = 1.0, h = 0.5 },
  upright30  = { x = 0.7, y = 0.0, w = 0.3, h = 0.5 },
  botright30 = { x = 0.7, y = 0.5, w = 0.3, h = 0.5 },
  upleft70   = { x = 0.0, y = 0.0, w = 0.7, h = 0.5 },
  botleft70  = { x = 0.0, y = 0.5, w = 0.7, h = 0.5 },
  right7080  = { x = 0.7, y = 0.0, w = 0.3, h = 0.8 }
}

layouts = {
  coding = {
    { name = 'Firefox', unit = units.left70 },
    { name = 'VimR',    unit = units.left70 },
    { name = 'iTerm2',  unit = units.right30 }
  },
  writing = {
    { name = 'Firefox', unit = units.left70 },
    { name = 'VimR',    unit = units.left70 },
    { name = 'iTerm2',  unit = units.right30 },
    { name = 'Skim',    unit = units.right7080 }
  }
}

function runLayout(layout)
  for i = 1,#layout do
    local t = layout[i]
    local win = hs.application.get(t.name):mainWindow()
    win:move(t.unit, nil, true)
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

hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move({ x = 0.0, y = 0.0, w = 1, h = 1}, nil, true) end)
hs.hotkey.bind(mash, '0', function() runLayout(layouts.coding) end)
hs.hotkey.bind(mash, '9', function() runLayout(layouts.writing) end)

-------------------------------------------------------------------
-- Launcher
-------------------------------------------------------------------

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
  hs.alert.show('App Launcher Mode', {
    strokeColor = hs.drawing.color.x11.orangered,
    fillColor = hs.drawing.color.x11.cyan,
    textColor = hs.drawing.color.x11.black,
    strokeWidth = 20,
    radius = 30,
    textSize = 128,
    fadeInDuration = 0.05,
    fadeOutDuration = 0.05
  }, 'infinite')
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
