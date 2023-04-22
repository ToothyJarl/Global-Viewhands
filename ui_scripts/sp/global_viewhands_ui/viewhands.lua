-- ;
-- ;  Written by ToothyJarl :: 4/12/2023
-- ;

local debug = 1

local menus = {}
local csv = "sp/level_info.csv"

local cols = {
	mapId = 0,
	mapString = 2
}

local count = Engine.TableGetRowCount(csv)


local individualViewhand = {}

local viewhands_list = [[
{
    "options": [
        {
            "value": "globalViewhands_h1_usmc_marine",
            "text": "Marines"
        },
        {
            "value": "globalViewhands_h1_sas_woodland",
            "text": "Woodland"
        },
        {
            "value": "globalViewhands_h1_sas_ct_mp_camo",
            "text": "Black Kit"
        },
        {
            "value": "globalViewhands_h1_sas_ct_mp_wet_camo",
            "text": "Black Kit Wet"
        },
        {
            "value": "globalViewhands_h1_marine_sniper",
            "text": "Ghillie"
        },
        {
            "value": "globalViewhands_h1_op_force_ult",
            "text": "Spetsnaz"
        },
        {
            "value": "globalViewhands_h1_spetsnaz_urban_mp_wet_camo",
            "text": "Spetsnaz Wet"
        },
        {
            "value": "globalViewhands_h1_arab_desert_mp_camo",
            "text": "OpFor"
        },
        {
            "value": "globalViewhands_h1_arab_desert_mp_fullsleeves_camo",
            "text": "OpFor Full Sleeve"
        }
    ]
}
]]

local image_desc = {
    ["globalViewhands_h1_usmc_marine"] = "USMC Marines Viewhands",
    ["globalViewhands_h1_sas_woodland"] = "SAS Woodland Viewhands",
    ["globalViewhands_h1_sas_ct_mp_camo"] = "Black Kit Viewhands",
    ["globalViewhands_h1_sas_ct_mp_wet_camo"] = "Black Kit Wet Viewhands",
    ["globalViewhands_h1_marine_sniper"] = "Ghillie Suit Viewhands",
    ["globalViewhands_h1_op_force_ult"] = "Spetsnaz Viewhands",
    ["globalViewhands_h1_spetsnaz_urban_mp_wet_camo"] = "Spetsnaz Wet Viewhands",
    ["globalViewhands_h1_arab_desert_mp_camo"] = "OpFor Viewhands",
    ["globalViewhands_h1_arab_desert_mp_fullsleeves_camo"] = "OpFor Full Sleeve Viewhands",
}  

local options = {}
local parsed_json = json.decode(viewhands_list)
for i, option in ipairs(parsed_json.options) do
    options[i] = option
end

function backbutton(menu)
    menu:AddBackButton(function(menu)
        Engine.PlaySound(CoD.SFX.MenuBack)
        LUI.FlowManager.RequestLeaveMenu(menu)
        PersistentBackground.ChangeBackground( nil, "sp_menus_bg_main_menu" )
    end)
end

function scrolllist(menu)
    LUI.Options.InitScrollingList(menu.list, nil)
    menu:CreateBottomDivider()
    menu.optionTextInfo = LUI.Options.AddOptionTextInfo(menu)
end

function UpdateDifficultyText( f32_arg0, f32_arg1, text )
    f32_arg0:setText( text )
end

function UpdateImage( f32_arg0, viewhand )
    f32_arg0:setImage( RegisterMaterial( "ui_" .. viewhand ) )
end


local imageDesc = ""

function createmenu(team)
    local teammenu = function(a1)
            
        local menu = LUI.MenuTemplate.new(a1, {
            menu_title = "VIEWHANDS",
            exclusiveController = 0,
            menu_width = 500,
            menu_top_indent = LUI.MenuTemplate.spMenuOffset,
            showTopRightSmallBar = true
        })
        

    

        LUI.Options.CreateOptionButton( menu, "globalViewhandsMode", "Mode", "Change which mode you want to use", {
            {
                text = "Individual",
                value = "individual"
            },
            {
                text = "Global",
                value = "global"
            }
        }, nil, nil, function (value)
            modeViewhand = value
            configFunctions.setMode(value)
            menu:RefreshButtonDisabled()
        end )

        local f0_local3 = 0
        local f0_local4 = PauseMenuAnimationSettings.MapGlitch.DurationIn / 7
        local f0_local5 = false
        local f0_local6 = false
        local f0_local7 = {
            Styles = {
                Minimap = {
                    Top = 155.66 - DesignGridDims.vert_gutter + f0_local3,
                    Right = DesignGridDims.horz_gutter - 35,
                    BackgroundWidth = 548,
                    BackgroundHeight = 308,
                    Width = 467,
                    Height = 257,
                    StretchingAnim = false
                },
                MapInfos = {
                    Top = 6 + f0_local3,
                    Right = DesignGridDims.horz_gutter - 71,
                    Spacing = 40
                },
                ObjectiveBox = {
                    Top = 118.66 - DesignGridDims.vert_gutter + f0_local3,
                    Left = GenericMenuDims.menu_width_standard + 2002
                },
                ObjectiveBar = {
                    Height = 3,
                    Left = -2
                },
                ObjectiveTitle = {
                    Top = 7 + f0_local3
                },
                ObjectiveList = {
                    Top = 38.16,
                    Left = 19,
                    Spacing = 20
                }
            },
            FirstOpening = false
        }

        function AddMiniMap( f30_arg0 )
            
        local f34_local1 = f0_local7.Styles.ObjectiveBox.Top + f0_local7.Styles.MapInfos.Top
        local f34_local2 = CoD.CreateState( nil, f34_local1, f0_local7.Styles.MapInfos.Right, nil, CoD.AnchorTypes.TopRight )
        f34_local2.height = CoD.TextSettings.BodyFontSmall.Height
        f34_local2.font = CoD.TextSettings.BodyFontSmall.Font
        f34_local2.color = Colors.h1.second_medium_grey
        f34_local2.alpha = 1
        imageDesc = LUI.UIText.new( f34_local2 )
            imageDesc.id = "difficultyText"
            imageDesc:registerAnimationState( "hidden", {
            alpha = 0
        } )
        imageDesc:registerEventHandler( "menu_create", UpdateDifficultyText(imageDesc, nil, "USMC Marines Viewhands") )
        f30_arg0:addElement( imageDesc )



            local f36_local7 = "PREVIEW"
            local f36_local8 = CoD.CreateState( -500, 40, 0, nil, CoD.AnchorTypes.TopRight )
            f36_local8.alignment = LUI.Alignment.Right
            f36_local8.font = CoD.TextSettings.TitleFontSmaller.Font
            f36_local8.height = CoD.TextSettings.TitleFontSmaller.Height
            f36_local8.color = Colors.h1.light_green
            local self = LUI.UIText.new( f36_local8 )
            self:setText( Engine.ToUpperCase( Engine.ToUpperCase( f36_local7 ) ) )
            f30_arg0:addElement( self )

            local f30_local0 = CoD.CreateState( nil, f0_local7.Styles.Minimap.Top, f0_local7.Styles.Minimap.Right, nil, CoD.AnchorTypes.TopRight )
            f30_local0.width = f0_local7.Styles.Minimap.BackgroundWidth
            f30_local0.height = f0_local7.Styles.Minimap.BackgroundHeight
            f30_local0.alpha = 1
            f30_local0.material = RegisterMaterial( "h1_bg_map" )
            local self = LUI.UIImage.new( f30_local0 )
            self.id = "map_mini_bg"
            f30_local0.material = nil
            f30_local0.right = f0_local7.Styles.Minimap.Right - f0_local7.Styles.Minimap.BackgroundWidth
            f30_local0.width = 0
            f30_local0.height = 0
            f30_local0.alpha = 0
            self:registerAnimationState( "hidden", f30_local0 )
            f30_local0.right = f0_local7.Styles.Minimap.Right - f0_local7.Styles.Minimap.BackgroundWidth * 0.75
            f30_local0.width = f0_local7.Styles.Minimap.BackgroundWidth * 0.25
            f30_local0.height = f0_local7.Styles.Minimap.BackgroundHeight * 0.7
            f30_local0.alpha = 0.5
            self:registerAnimationState( "animation_state_1", f30_local0 )
            f30_local0.right = f0_local7.Styles.Minimap.Right - f0_local7.Styles.Minimap.BackgroundWidth * 0.3
            f30_local0.width = f0_local7.Styles.Minimap.BackgroundWidth * 0.7
            f30_local0.height = f0_local7.Styles.Minimap.BackgroundHeight * 0.9
            f30_local0.alpha = 0.8
            self:registerAnimationState( "animation_state_2", f30_local0 )
            f30_local0.right = f0_local7.Styles.Minimap.Right + f0_local7.Styles.Minimap.BackgroundWidth * 0.02
            f30_local0.width = f0_local7.Styles.Minimap.BackgroundWidth * 1.02
            f30_local0.height = f0_local7.Styles.Minimap.BackgroundHeight * 1.02
            f30_local0.alpha = 1
            self:registerAnimationState( "animation_state_3", f30_local0 )
            f30_local0.top = f0_local7.Styles.Minimap.Top + f0_local7.Styles.Minimap.BackgroundHeight / 2
            f30_local0.right = f0_local7.Styles.Minimap.Right
            f30_local0.width = f0_local7.Styles.Minimap.BackgroundWidth
            f30_local0.height = 0
            f30_local0.alpha = 0
            self:registerAnimationState( "hidden_anim_stretching", f30_local0 )
            self:registerAnimationState( "inactive", {
                alpha = 0
            } )
            self:registerEventHandler( "menu_create", OnMiniMapBGCreate )
            f30_arg0:addElement( self )
            local f30_local2 = LUI.MenuBuilder.BuildRegisteredType( "UIMinimap", {
                compassType = CoD.CompassType.Partial,
                defAnimState = {
                    width = f0_local7.Styles.Minimap.Width,
                    height = f0_local7.Styles.Minimap.Height,
                    alpha = 1
                }
            } )
            f30_local2.id = "map_mini_id"
            f30_local2:registerAnimationState( "hidden", {
                alpha = 0
            } )
            f30_local2:registerEventHandler( "menu_create" )
            self:addElement( f30_local2 )
            
            local f30_local5 = {
                width = f0_local7.Styles.Minimap.Width,
                height = f0_local7.Styles.Minimap.Height,
                material = RegisterMaterial( "ui_globalViewhands_h1_usmc_marine" ),
                alpha = 1,
                zRot = 0
            }

            image_main = LUI.UIImage.new( f30_local5 )


            

            f30_local5.zRot = -90
            image_main:registerAnimationState( "rot_90", f30_local5 )
            f30_local5.zRot = -180
            image_main:registerAnimationState( "rot_180", f30_local5 )
            f30_local5.zRot = -270
            image_main:registerAnimationState( "rot_270", f30_local5 )
            image_main:registerEventHandler( "menu_create" )
            f30_local2:addElement( image_main )
            local f30_local7 = {
                width = f0_local7.Styles.Minimap.Width,
                height = f0_local7.Styles.Minimap.Height,
                alpha = 0,
                zRot = 0
            }
            local self = LUI.UIImage.new( f30_local7 )
            self.id = "map_glitch_id"
            self:registerAnimationState( "wait", {
                alpha = 0
            } )
            f30_local7.alpha = 0.25
            self:registerAnimationState( "opacity50_rot0", f30_local7 )
            f30_local7.zRot = 180
            self:registerAnimationState( "opacity50_rot180", f30_local7 )
            self:registerEventHandler( "menu_create", OnMiniMapGlitchCreate )
            self:registerEventHandler( "transition_step_complete_wait", function ( element, event )
                local f31_local0 = element:getParent()
                f31_local0:dispatchEventToChildren( {
                    name = "startGlitch"
                } )
            end )
            f30_local2:addElement( self )
            local f30_local9 = {
                width = f0_local7.Styles.Minimap.Width,
                height = f0_local7.Styles.Minimap.Height,
                material = RegisterMaterial( "white" ),
                alpha = 0
            }
            local self = LUI.UIImage.new( f30_local9 )
            self.id = "map_white_square_id"
            f30_local9.alpha = 0.75
            self:registerAnimationState( "opacity10", f30_local9 )
            self:registerEventHandler( "startGlitch", OnStartGlitchWhiteSquare )
            f30_local2:addElement( self )
            local f30_local11 = {
                width = f0_local7.Styles.Minimap.Width,
                height = f0_local7.Styles.Minimap.Height,
                material = RegisterMaterial( "black" ),
                alpha = 0
            }
            local self = LUI.UIImage.new( f30_local11 )
            self.id = "map_black_square_id"
            f30_local11.alpha = 0.75
            self:registerAnimationState( "opacity15", f30_local11 )
            self:registerEventHandler( "startGlitch", OnStartGlitchBlackSquare )
            f30_local2:addElement( self )
        end

        AddMiniMap(menu)


        createdivider(menu, "Global")

        LUI.Options.CreateOptionButton(menu, "globalViewhands_global", "Viewhand", "Set a global viewhand for: ^2All Maps", options, nil, function () 
            return Engine.GetDvarString( "globalViewhandsMode" ) == "individual"
        end, function(value)
            UpdateImage(image_main, value)
            UpdateDifficultyText(imageDesc, nil, image_desc[value])
            globalViewhand = value
            configFunctions.setGlobalViewhand(value)
        end)

    
        createdivider(menu, "Individual")



        for i = 0, count - 2 do
            local mapId = Engine.TableLookupByRow(csv, i, cols.mapId)
            local mapString = Engine.TableLookupByRow(csv, i, cols.mapString)
            local mapHighlighted = ""

            if Engine.GetDvarString("mapname") == mapId and not Engine.InFrontend() then
                mapHighlighted = "^2"
            end
            
            LUI.Options.CreateOptionButton(menu, "globalViewhands_" .. mapId, mapHighlighted .. Engine.Localize(mapString), "Set an individual viewhand for: ^2" .. Engine.Localize(mapString), options, nil, function() 
                return Engine.GetDvarString( "globalViewhandsMode" ) == "global"
            end, function(value)
                UpdateImage(image_main, value)
                UpdateDifficultyText(imageDesc, nil, image_desc[value])
                configFunctions.setMapViewhand(mapId, value)
                configFunctions.loadConfigToDvars()
            end)
        end

        PersistentBackground.ChangeBackground( nil, "h1_menu_background_vignette" )
            
        backbutton(menu)
        scrolllist(menu)

        

        return menu
    end

    LUI.MenuBuilder.registerType("viewhand", teammenu)
end

createmenu("viewhands")
