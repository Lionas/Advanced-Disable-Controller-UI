-- Advanced Disable Controller UI Menu
-- Author: Lionas
local PanelTitle = "Advanced Disable Controller UI"
local Version = "1.0"
local Author = "Lionas"

local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

function LoadLAM2Panel()
    local PanelData = 
    {
        type = "panel",
        name = PanelTitle,
        author = Author,
        version = Version,
        slashCommand = "/adcui",
    }
    local OptionsData = 
    {
        [1] =
        {
            type = "description",
            text = GetString(ADCUI_DESCRIPTION),
        },
        [2] = 
        {
            type = "checkbox",
            name = GetString(ADCUI_LOCK_TITLE),
            tooltip = GetString(ADCUI_LOCK_TOOLTIP),
            getFunc = 
              function() 
                return ADCUI.PREFS.lock
              end,
            setFunc = 
              function(value) 
                ADCUI.PREFS.lock = value
                ADCUI:adjustCompass()
              end,
        },
        [3] = 
        {
            type = "editbox",
            name = GetString(ADCUI_SCALE_TITLE),
            tooltip = GetString(ACCUI_SCALE_TOOLTIP),
            getFunc = 
              function() 
                return ADCUI.PREFS.scale
              end,
            setFunc = 
              function(value) 
                ADCUI.PREFS.scale = tonumber(value)
                ADCUI:frameUpdate()
              end,
        },
        [4] = 
        {
            type = "editbox",
            name = GetString(ADCUI_WIDTH_TITLE),
            tooltip = GetString(ADCUI_WIDTH_TOOLTIP),
            getFunc = 
              function()
                return ADCUI.PREFS.width
              end,
            setFunc = 
              function(value)
                ADCUI.PREFS.width = tonumber(value) 
                ADCUI:frameUpdate() 
              end,
        },
        [5] = 
        {
            type = "editbox",
            name = GetString(ADCUI_HEIGHT_TITLE),
            tooltip = GetString(ADCUI_HEIGHT_TOOLTIP),
            getFunc = 
              function() 
                return ADCUI.PREFS.height 
              end,
            setFunc = 
              function(value) 
                ADCUI.PREFS.height = tonumber(value) 
                ADCUI:frameUpdate() 
              end,
        },
        [6] = 
        {
            type = "editbox",
            name = GetString(ADCUI_PIN_SCALE_TITLE),
            tooltip = GetString(ADCUI_PIN_SCALE_TOOLTIP),
            getFunc = 
              function() 
                return ADCUI.PREFS.pinLabelScale 
              end,
            setFunc = 
              function(value) 
                ADCUI.PREFS.pinLabelScale = tonumber(value) 
                ADCUI:frameUpdate()
              end,
        },
    }   
    
    LAM2:RegisterAddonPanel(PanelTitle.."LAM2Options", PanelData)
    LAM2:RegisterOptionControls(PanelTitle.."LAM2Options", OptionsData)
    
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------