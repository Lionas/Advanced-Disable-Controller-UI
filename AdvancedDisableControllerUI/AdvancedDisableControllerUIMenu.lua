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
                return ADCUI.savedVariables.lock
              end,
            setFunc = 
              function(value) 
                ADCUI.savedVariables.lock = value
                ADCUI:adjustCompass()
              end,
        },
        [3] = 
        {
            type = "slider",
            name = GetString(ADCUI_SCALE_TITLE),
            tooltip = GetString(ACCUI_SCALE_TOOLTIP),
			min = 8,
			max = 11,
			step = 1,
			default = ADCUI.savedVariables.scale * 10,
            getFunc = 
              function() 
                return ADCUI.savedVariables.scale * 10
              end,
            setFunc = 
              function(value) 
                ADCUI.savedVariables.scale = tonumber(value) / 10.0
                ADCUI:frameUpdate()
              end,
        },
        [4] = 
        {
            type = "slider",
            name = GetString(ADCUI_WIDTH_TITLE),
            tooltip = GetString(ADCUI_WIDTH_TOOLTIP),
			min = 0,
			max = 1500,
			step = 10,
			default = ADCUI.savedVariables.width,
            getFunc = 
              function()
                return ADCUI.savedVariables.width
              end,
            setFunc = 
              function(value)
                ADCUI.savedVariables.width = tonumber(value) 
                ADCUI:frameUpdate() 
              end,
        },
        [5] = 
        {
            type = "slider",
            name = GetString(ADCUI_HEIGHT_TITLE),
            tooltip = GetString(ADCUI_HEIGHT_TOOLTIP),
			min = 0,
			max = 100,
			step = 1,
			default = ADCUI.savedVariables.height,
            getFunc = 
              function() 
                return ADCUI.savedVariables.height 
              end,
            setFunc = 
              function(value) 
                ADCUI.savedVariables.height = tonumber(value) 
                ADCUI:frameUpdate() 
              end,
        },
        [6] = 
        {
            type = "slider",
            name = GetString(ADCUI_LABEL_SCALE_TITLE),
            tooltip = GetString(ADCUI_LABEL_SCALE_TOOLTIP),
			min = 6,
			max = 11,
			step = 1,
			default = ADCUI.savedVariables.pinLabelScale * 10,
            getFunc = 
              function() 
                return ADCUI.savedVariables.pinLabelScale * 10
              end,
            setFunc = 
              function(value) 
                ADCUI.savedVariables.pinLabelScale = tonumber(value) / 10.0
                ADCUI:frameUpdate()
              end,
        },
    }   
    
    LAM2:RegisterAddonPanel(PanelTitle.."LAM2Options", PanelData)
    LAM2:RegisterOptionControls(PanelTitle.."LAM2Options", OptionsData)
    
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------