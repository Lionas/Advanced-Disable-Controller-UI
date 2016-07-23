-- Advanced Disable Controller UI
-- Author: Lionas
ADCUI = {}
ADCUI.PREFS = {}
ADCUI.default = 
{
  -- default values
  scale = 1,
  width = 550,
  height = 30,
  point = TOPRIGHT,
  lockEnabled = false,
  dimWidth = 10,
  dimHeight = 35,
  dimFrameWidth = 550,
  anchorOffsetX = 1500,
  anchorOffsetY = 75,
  anchorPosition = TOPRIGHT,
  movable = true,
  mouseEnabled = false,
  clamped = false,
}

local LAYER_TOP = -1
local myAddonName = "AdvancedDisableControllerUI"

-- disable gamepad mode
function IsInGamepadPreferredMode()
	return false
end

-- Initialize preferences
local function initializePrefs()
  
  ADCUI.PREFS = ZO_SavedVars:New("AdvancedDisableControllerUI_SavedPrefs", 1, nil,
    {
      scale = ADCUI.default.scale,
      pinLabelScale = ADCUI.default.scale,
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

  ZO_CompassFrame:ClearAnchors()
  
  -- lock/unlock compass
  if(ADCUI.PREFS.lock) then
    -- lock
    ZO_CompassFrame:SetMovable(false)
    ZO_CompassFrame:SetMouseEnabled(false)
  else
    -- unlock
    ZO_CompassFrame:SetMovable(true)
    ZO_CompassFrame:SetMouseEnabled(true)
  end

  -- redraw compass
  ZO_CompassFrame:SetAnchor(ADCUI.PREFS.point, GuiRoot, nil, ADCUI.PREFS.x, ADCUI.PREFS.y) -- load saved compass position
  ZO_CompassFrame:SetClampedToScreen(ADCUI.default.clamped) -- prevent draging off screen
  ZO_CompassFrame:SetDrawLayer(LAYER_TOP)

end

-- frame update
function ADCUI:frameUpdate()

  ZO_Compass:SetScale(ADCUI.PREFS.scale)
  ZO_Compass:SetDimensions(ADCUI.PREFS.width, ADCUI.PREFS.height)
  ZO_CompassCenterOverPinLabel:SetScale(ADCUI.PREFS.pinLabelScale)
  ZO_CompassFrameLeft:SetDimensions(ADCUI.default.dimWidth, ADCUI.PREFS.height)
  ZO_CompassFrameRight:SetDimensions(ADCUI.default.dimWidth, ADCUI.PREFS.height)
  ZO_CompassFrame:SetDimensions(ADCUI.PREFS.width, ADCUI.PREFS.height)

end

-- update panel
local function loadMenuPanel()
  
  LoadLAM2Panel() -- load Menu Settings
  EVENT_MANAGER:UnregisterForEvent("AdvancedDisableControllerUI_Player", EVENT_PLAYER_ACTIVATED) -- unregist event handler
  
  ADCUI:frameUpdate()
  ADCUI:adjustCompass()
  
end

-- OnLoad
local function onLoad(event, addon)
  
  if(addon ~= myAddonName) then
    return
  end
  
  initializePrefs()
  ADCUI:adjustCompass()
  
  ZO_CompassFrame:SetHandler("OnUpdate", frameUpdate)
  EVENT_MANAGER:RegisterForEvent("AdvancedDisableControllerUI_Player", EVENT_PLAYER_ACTIVATED, loadMenuPanel)
  
  EVENT_MANAGER:UnregisterForEvent("AdvancedDisableControllerUI_OnLoad", EVENT_ADD_ON_LOADED) -- unregist event handler
 
end

-- Update variables
local function onUpdateVars()
  
  local anchor, point, rTo, rPoint, offsetx, offsety = ZO_CompassFrame:GetAnchor() 
    
  if(offsetx ~= ADCUI.PREFS.x or offsety ~= ADCUI.PREFS.y) then
    
    ADCUI.PREFS.x = offsetx
    ADCUI.PREFS.y = offsety
    ADCUI.PREFS.point = point
  
    if(rPoint ~= nil) then
      ADCUI.PREFS.point = rPoint
    end
  
--  d("x="..ADCUI.PREFS.x..", y="..ADCUI.PREFS.y..", point="..ADCUI.PREFS.point)
  
  end
  
end  

-- Regist event handler
EVENT_MANAGER:RegisterForEvent("AdvancedDisableControllerUI_OnLoad", EVENT_ADD_ON_LOADED, onLoad)
EVENT_MANAGER:RegisterForEvent("AdvancedDisableControllerUI_Vars", EVENT_GLOBAL_MOUSE_UP, onUpdateVars)
