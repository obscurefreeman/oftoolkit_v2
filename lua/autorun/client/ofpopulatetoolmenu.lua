AddCSLuaFile( )

local function of_populatetoolmenu( pnl )

	pnl:ControlHelp( "工具箱设置" )
	pnl:CheckBox( "将这些菜单迁移到单独的选项卡" , "of_populatetoolmenu" )
    pnl:Help("重启或重载游戏生效。")

	

end

hook.Add( "PopulateToolMenu", "OFMenus", function( )
    if ( GetConVarNumber( "of_populatetoolmenu" ) == nil or GetConVarNumber( "of_populatetoolmenu" ) == 0 ) then
	    spawnmenu.AddToolMenuOption( "Options" , "Obscurefreeman's mod" , "of_populatetoolmenu" , " Main Settings " , "" , "" , of_populatetoolmenu )
    else
        hook.Add("AddToolMenuTabs", "addofpopulatetoolmenu", addofpopulatetoolmenu)
        addofpopulatetoolmenu()
        spawnmenu.AddToolMenuOption( "OFmod" , "Tools" , "of_populatetoolmenu" , " Main Settings " , "" , "" , of_populatetoolmenu )
    end
end )

function addofpopulatetoolmenu()
	return spawnmenu.AddToolTab("OFmod", "OFmod", "gui/silkicons/oftoollogo")
end