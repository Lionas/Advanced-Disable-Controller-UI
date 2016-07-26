-- Advanced Disable Controller UI
-- Author: Lionas
ADCUI = {}

ADCUI.default = 
{
  -- default values
  scale = 1,
  width = 550,
  height = 30,
  point = TOP,
  lockEnabled = false,
  dimWidth = 10,
  dimHeight = 35,
  dimFrameWidth = 550,
  anchorOffsetX = 0,
  anchorOffsetY = 40,
  anchorPosition = TOP,
  movable = true,
  mouseEnabled = false,
  clamped = false,
  pinLabelScale = 1,
}

local LAYER_TOP = -1
local myAddonName = "AdvancedDisableControllerUI"
local UPDATE_INTERVAL_MSEC = 5000
local lockPicking = false

-- disable gamepad mode
function IsInGamepadPreferredMode()

    -- enable gamepad mode while lockpicking
    return lockPicking

end

-- Initialize preferences
local function initializePrefs()

  ADCUI.savedVariables = ZO_SavedVars:New("AdvancedDisableControllerUI_SavedPrefs", 1, nil,
    {
      scale = ADCUI.default.scale,
      pinLabelScale = ADCUI.default.pinLabelScale,
      width = ADCUI.default.width,
      height = ADCUI.default.height,
      x = ADCUI.default.anchorOffsetX,
      y = ADCUI.default.anchorOffsetY,
      point = ADCUI.default.point,
      lock = ADCUI.default.lockEnabled,
    }
  )
  
end

-- Adjust Compass
function ADCUI:adjustCompass()

--d("adjustCompass")

  -- unlock
  ZO_CompassFrame:SetMovable(true)
  ZO_CompassFrame:SetMouseEnabled(true)

  ZO_CompassFrame:ClearAnchors()

  -- redraw compass
  ZO_CompassFrame:SetAnchor(ADCUI.savedVariables.point, GuiRoot, nil, ADCUI.savedVariables.x, ADCUI.savedVariables.y) -- load saved compass position
  ZO_CompassFrame:SetClampedToScreen(ADCUI.default.clamped) -- prevent draging off screen
  ZO_CompassFrame:SetDrawLayer(LAYER_TOP)

  -- lock/unlock compass
  if(ADCUI.savedVariables.lock) then
    -- lock
    ZO_CompassFrame:SetMovable(false)
    ZO_CompassFrame:SetMouseEnabled(false)
  else
    -- unlock
    ZO_CompassFrame:SetMovable(true)
    ZO_CompassFrame:SetMouseEnabled(true)
  end

end

-- frame update
function ADCUI:frameUpdate()

--d("frameUpdate")

  ZO_Compass:SetScale(ADCUI.savedVariables.scale)
  ZO_Compass:SetDimensions(ADCUI.savedVariables.width, ADCUI.savedVariables.height)
  ZO_CompassCenterOverPinLabel:SetScale(ADCUI.savedVariables.pinLabelScale)
  ZO_CompassFrameLeft:SetDimensions(ADCUI.default.dimWidth, ADCUI.savedVariables.height)
  ZO_CompassFrameRight:SetDimensions(ADCUI.default.dimWidth, ADCUI.savedVariables.height)
  ZO_CompassFrame:SetDimensions(ADCUI.savedVariables.width, ADCUI.savedVariables.height)

end

-- update compass
local function onUpdateCompass()

--d("onUpdateCompass")

  local anchor, point, rTo, rPoint, offsetx, offsety = ZO_CompassFrame:GetAnchor() 
    
  if((offsetx ~= ADCUI.savedVariables.x) or (offsety ~= ADCUI.savedVariables.y)) then

    ADCUI:frameUpdate()
    ADCUI:adjustCompass()

  end

end

-- update panel
local function loadMenuPanel()

--d("loadMenuPanel")
  
  LoadLAM2Panel() -- load Menu Settings
  EVENT_MANAGER:UnregisterForEvent("AdvancedDisableControllerUI_Player", EVENT_PLAYER_ACTIVATED) -- unregist event handler
  
end

-- OnLoad
local function onLoad(event, addon)
  
  if(addon ~= myAddonName) then
    return
  end
  
  initializePrefs()
  onUpdateCompass()
  
  ZO_CompassFrame:SetHandler("OnUpdate", frameUpdate)
  EVENT_MANAGER:RegisterForEvent("AdvancedDisableControllerUI_Player", EVENT_PLAYER_ACTIVATED, loadMenuPanel)
  
  EVENT_MANAGER:UnregisterForEvent("AdvancedDisableControllerUI_OnLoad", EVENT_ADD_ON_LOADED) -- unregist event handler
 
end

-- onCraftStationInteract
local function onCraftStationInteract(event, addon)
  
  -- Prevent ESO UI bug -- interaction freezing
  CALLBACK_MANAGER:FireCallbacks("CraftingAnimationsStopped")
 
end

-- Update variables
local function onUpdateVars()

--d("onUpdateVars")
  
  local anchor, point, rTo, rPoint, offsetx, offsety = ZO_CompassFrame:GetAnchor() 
    
  if((offsetx ~= ADCUI.savedVariables.x and offsetx ~= ADCUI.default.anchorOffsetX)
      or 
     (offsety ~= ADCUI.savedVariables.y and offsety ~= ADCUI.default.anchorOffsetY)) then
    
    ADCUI.savedVariables.x = offsetx
    ADCUI.savedVariables.y = offsety
    ADCUI.savedVariables.point = point
  
    if(rPoint ~= nil) then
      ADCUI.savedVariables.point = rPoint
    end
  
--d("x="..ADCUI.savedVariables.x..", y="..ADCUI.savedVariables.y..", point="..ADCUI.savedVariables.point)
  
  end
  
end  

-- handling lockpicking
local function onStartLockPicking()

  lockPicking = true

end

local function onFinishLockPicking()

  lockPicking = false

end

-- Regist event handler
EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_ADD_ON_LOADED, onLoad)
EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_GLOBAL_MOUSE_UP, onUpdateVars)
EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_GLOBAL_MOUSE_DOWN, onUpdateVars)
EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_CRAFT_COMPLETED, onCraftStationInteract)

EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_BEGIN_LOCKPICK, onStartLockPicking)
EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_LOCKPICK_FAILED, onFinishLockPicking)
EVENT_MANAGER:RegisterForEvent(myAddonName, EVENT_LOCKPICK_SUCCESS, onFinishLockPicking)

EVENT_MANAGER:RegisterForUpdate(myAddonName, UPDATE_INTERVAL_MSEC, onUpdateCompass)
