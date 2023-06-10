

AddCSLuaFile()

--[[
这里是晦涩弗里曼，很高兴有人能看到这段注释
感谢你能关注或参考这个模组。
晦涩弗里曼
2033.2.13
]]--

CreateConVar( "of_god", "0", 128, "" )		--无敌
CreateConVar( "of_drawwm", "1", 0, "" )		--第三人称模型
CreateConVar( "of_skybox", "1", 0, "" )		--隐藏地图细节
CreateConVar( "of_drawhud", "1", 0, "" )	--显示多余元素
CreateConVar( "of_thirdperson", "1", 0, "" )	--显示第三人称模型
CreateConVar( "of_setasrespawn", "0",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )	--死后设为出生点
CreateConVar( "of_spawngod", "0",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )	--3秒无敌
CreateConVar( "of_explodafterdeath", "0",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )	--死后原地爆炸
--CreateConVar( "of_allowweaponsinvehicle", "0", 0, "" )	--载具允许武器

--CreateConVar( "nb_stop", "1", 0, "" )		--NEXTBOT
--CreateConVar( "nb_targetmethod", "1", 0, "" )
--CreateConVar( "ai_ignoplayers", "1", 0, "" )
--CreateConVar( "nb_doordination", "1", 0, "" )
--CreateConVar( "nb_friendlyfire", "1", 0, "" )
--CreateConVar( "nb_allow_backingup", "1", 0, "" )
--CreateConVar( "nb_solder_findreloadspot", "1", 0, "" )
--CreateConVar( "nb_death_animations", "1", 0, "" )

CreateConVar( "npc_model_randomizer_chosen", "1", 0, "" )		--随机皮肤
CreateConVar( "npc_model_randomizer_skin_random", "1", 0, "" )
CreateConVar( "npc_model_randomizer_bodygroups_random", "1", 0, "" )
CreateConVar( "npc_model_randomizer_combine_s", "1", 0, "" )
CreateConVar( "npc_model_randomizer_citizen", "1", 0, "" )
CreateConVar( "npc_model_randomizer_metropolice", "1", 0, "" )

CreateConVar( "sv_drawmapio", "1", 0, "" )		--合并路点

--CreateConVar( "kn_realistic_combine", "1", 0, "" )		--智能联合军

CreateConVar( "z_npc_nav_enabled" , "1", 0, "" )		--寻路






local LastPlace = Vector( 0, 0, 0 )	--上次玩家死的地方，默认000
local SavePlace = Vector( 0, 0, 0 ) --保存的地方，默认000
local PlySpawnPlace = Vector( 0, 0, 0 ) --出生点，默认000

local NoCheats = "没有打开sv_cheats 1，操作失败！"	

concommand.Add( "of_clean", function( ply )	--清理尸体和贴图
	RunConsoleCommand( "g_ragdoll_fadespeed", "9999"  )		--尸体快速消失
	RunConsoleCommand( "g_ragdoll_maxcount", "0" )		--布娃娃消失
	RunConsoleCommand( "r_cleardecals" )		--清理贴图
	timer.Simple( 1, function() 
		RunConsoleCommand( "g_ragdoll_fadespeed","600" ) 
		RunConsoleCommand( "g_ragdoll_maxcount", "30" ) 
	end )	--1秒后恢复
end )

concommand.Add( "of_cleanup", function( ply )	--清理全部
	game.CleanUpMap()
end )

concommand.Add( "of_removeallweapons", function( ply )	--缴械
	ply:StripWeapons()
end )

			game.CleanUpMap()

concommand.Add( "of_screenshot", function( ply )	--无损截屏
	timer.Simple( 2, function() 
		RunConsoleCommand( "screenshot" ) 
	end )	--2秒后截图
end )

concommand.Add( "of_reload", function( ply )	--1秒后重载
	timer.Simple( 1, function() 
		RunConsoleCommand( "reload" ) 
	end )	--没什么好说的
end )

hook.Add("PlayerDeath", "of_playerdie", function(ply)  --如果玩家死了
	LastPlace = ply:GetPos() --记录玩家死的地方
end)

concommand.Add( "of_death", function( ply )	--瞬移到上次死亡的地方
	ply:SetPos( LastPlace )	
end )

concommand.Add( "of_teleportsave", function( ply ) --保存
	SavePlace = ply:GetPos()
	ply:ChatPrint("位置已保存")
end)

concommand.Add( "of_teleport", function( ply )	--瞬移
	ply:SetPos( SavePlace )	
end )

concommand.Add( "of_teleporteyetrace", function( ply )	--瞬移玩家
	ply:SetPos( ply:GetEyeTrace().HitPos )
end )

concommand.Add( "of_saveasplayerspawn", function( ply ) --保存出生点
	PlySpawnPlace = ply:GetPos()
	if( GetConVarNumber( "of_setasrespawn" ) == 0 ) then

		ply:ChatPrint("出生点已保存")
		hook.Add("PlayerSpawn", "of_playerspawn", function(ply)  --如果玩家生成
			if( GetConVarNumber( "of_setasrespawn" ) == 0 ) then

				ply:SetPos( PlySpawnPlace )	
				
			else end
			
		end)	
		
	else 
		ply:ChatPrint("你已开启自动把死亡的位置设置为出生点！因此无法保存！")
	
	end
	
end)

concommand.Add( "of_deleteplayerspawn", function( ply ) --删除它们
	hook.Remove("PlayerSpawn", "of_playerspawn")
	ply:ChatPrint("出生点已被删除")
end)

hook.Add("PlayerDeath", "of_setlastplacasrespawnhook1", function( ply )
	if( GetConVarNumber( "of_setasrespawn" ) == 1 ) then
		hook.Add("PlayerSpawn", "of_setlastplacasrespawnhook2", function( ply )  --死后自动保存位置为出生点
			

			ply:SetPos( LastPlace )	
				
			
		end)
	else
		hook.Remove("PlayerSpawn", "of_setlastplacasrespawnhook2")
	end
end)

hook.Add("PlayerSpawn", "of_spawngodhook", function( ply ) --无敌3秒
	
	if( GetConVarNumber( "of_god" ) == 1 ) then return end

	if( GetConVarNumber( "of_spawngod" ) == 1 ) then
		RunConsoleCommand( "of_god","1" ) 
		timer.Simple( 3, function() 
			RunConsoleCommand( "of_god","0" ) 
		end )
		
		
	else end	
		
	
	
end)





--[[
util.AddNetworkString("of_allowweaponsinvehiclenet")

net.Receive("of_allowweaponsinvehiclenet", function(len, pl)
	if GetConVar("of_allowweaponsinvehicle"):GetInt() == 0 then return end
	if pl:GetAllowWeaponsInVehicle() == true then
		pl:SetAllowWeaponsInVehicle(false)
	else
		pl:SetAllowWeaponsInVehicle(true)
	end
	
end)



hook.Add("Think", "of_allowweaponsinvehiclehook", function( ply ) --车内可开火

	if( GetConVarNumber( "of_allowweaponsinvehicle" ) == 1 ) then
		ply:SetAllowWeaponsInVehicle(true)
		
		
	else 
		ply:SetAllowWeaponsInVehicle(false)
	end	
		
	
	
end)
]]--

hook.Add("PlayerDeath", "of_explodafterdeathhook", function(ply)  --死后爆炸
	if( GetConVarNumber( "of_explodafterdeath" ) == 1 ) then
		local ent = ents.Create ("env_explosion")
		ent:SetPos( ply:GetPos() )
		ent:SetOwner( ply )
		ent:SetKeyValue("iMagnitude","300")
		ent:Spawn()  				 --放
		ent:Fire("Explode", 0, 0 )
		
		
	else end
end)



concommand.Add( "of_fase", function( ply )	--选中脸
	ply:GetTool("faceposer"):SetFacePoserEntity( ply )
	RunConsoleCommand( "gmod_tool", "faceposer" )
end )


hook.Add("PlayerTick", "of_important1", function( ply )  --第三人称武器&无敌都在这里！！！！！！！！！
	if ( SERVER ) then 
	ply:DrawWorldModel( GetConVarNumber( "of_drawwm" ) == 1 ) 
		if GetConVarNumber( "of_god" ) == 1 then
			ply:GodEnable()
		else
			ply:GodDisable()
		end	
	end
end)

hook.Add("PlayerTick", "of_thirdpersonhook", function( ply ) 
	if( GetConVarNumber( "of_thirdperson" ) == 1 ) then
		
		if ( GetConVarNumber( "of_drawwm" ) == 0 ) then
			ply:SetColor( Color( 255, 255, 255, 255 ) )
			
			
			RunConsoleCommand( "of_drawwm", 1 ) 
			
			
		else end	
		
	else 
		if ( GetConVarNumber( "of_drawwm" ) == 1 ) then
			ply:SetRenderMode( RENDERMODE_TRANSALPHA )
			ply:SetColor( Color( 255, 255, 255, 0 ) )
			RunConsoleCommand( "of_drawwm", 0 ) 

		else end	
	
		
	end
end)

--[[
concommand.Add( "of_drawtp", function( ply )
	hook.Add("PlayerTick", "of_drawtp2", function( ply ) 
		if ( GetConVarNumber( "of_drawwm" ) == 1 ) then 
			ply:SetColor( Color( 255, 255, 255, 255 ) ) 
		else
			ply:SetRenderMode( RENDERMODE_TRANSALPHA )
			ply:SetColor( Color( 255, 255, 255, 0 ) )
		end 
	end)
	
end )
]]--
concommand.Add( "of_hpp", function( ply )	--暴力加血
	ply:SetHealth( ply:Health() + 100 )
	ply:ChatPrint("快速加血成功，你的生命值现在是："  ..   ply:Health()  )
end )


if ( SERVER ) then return end	--下面的部分不能给服务器用

hook.Add("Think", "of_hud", function( ply )
	local i = "0"
	if ( GetConVarNumber( "of_drawhud" ) == 1 ) then
		i = "1" 
	end
	RunConsoleCommand( "cl_drawhud", i )	--HUD显示
	RunConsoleCommand( "physgun_drawbeams", i )	--物理枪射线
	RunConsoleCommand( "physgun_halo", i )	--物理枪光圈
	RunConsoleCommand( "gmod_drawhelp", i )	--工具帮助
	RunConsoleCommand( "effects_unfreeze", i )	--解冻物品
	RunConsoleCommand( "effects_freeze", i )	--锁定物品
	RunConsoleCommand( "cl_draweffectrings", i )	--圆环
	RunConsoleCommand( "gmod_drawtooleffects", i )	--工具外置特效
	RunConsoleCommand( "cl_drawcameras", i )	--摄像机模型
end)

--[[
concommand.Add( "of_hide", function( ply )	--隐藏天空盒/雾/物体
	local i = "0"
	if ( GetConVarNumber( "r_skybox" ) == 0 ) then
		i = "1" 
	end	--如果天空盒有的话
	RunConsoleCommand( "r_skybox", i )	--天空盒
	RunConsoleCommand( "fog_enable", i )	--雾
	RunConsoleCommand( "r_drawstaticprops", i )	--物体
end)
]]--

hook.Add("Think", "of_skyboxhook", function( ply )  --天空盒
	local i = "0"
	if ( GetConVarNumber( "of_skybox" ) == 1 ) then
		i= "1"
	end
	RunConsoleCommand( "r_skybox", i )	--天空盒
	RunConsoleCommand( "fog_enable", i )	--雾
	RunConsoleCommand( "r_drawstaticprops", i )	--物体 

end)

concommand.Add( "of_1024", function( ply )	--红框
	local i = "1024"
	if ( GetConVarNumber( "cl_leveloverviewmarker" ) == 1024 ) then
		i = "0" 
	end
	RunConsoleCommand( "cl_leveloverviewmarker", i )
end)

--[[
concommand.Add( "of_hidethirdperson", function( ply )	--第三人称模型
	local i = "0"
	if ( GetConVarNumber( "of_drawwm" ) == 0 ) then	--读取玩家武器模型有没有显示
		i = "1" 
	end
	RunConsoleCommand( "of_drawwm", i )
	timer.Simple( 0.01, function() 
        RunConsoleCommand( "of_drawtp")
	end )
end)


hook.Add("PlayerTick", "of_drawtp", function( ply )	--第三人称模型之控制人物模型
	if ( GetConVarNumber( "of_drawwm" ) == 1 ) then 
		ply:SetColor( Color( 255, 255, 255, 255 ) ) 
		ply:ChatPrint( "第三人称模型显示。" )
	else
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetColor( Color( 255, 255, 255, 0 ) )
		ply:ChatPrint( "第三人称模型隐藏。" )
	end
end )
]]--
--！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
hook.Add( "PopulateMenuBar", "oftoolkit", function( menubar )

	local m = menubar:AddOrGetMenu( "晦弗工具箱V2" )	--主菜单
	RunConsoleCommand("r_drawvgui" , 1 )
	m:AddOption("打开晦弗工具箱", function() RunConsoleCommand( "of_menu") end):SetIcon("icon16/wrench_orange.png")
	--m:AddOption( "一键隐藏多余元素", function() RunConsoleCommand( "of_hud") end ):SetIcon("icon16/attach.png")
	m:AddCVar( "保留多余界面元素", "of_drawhud", "1", "0" ):SetIcon("icon16/attach.png")
	
	m:AddOption( "收拾残局", function() RunConsoleCommand( "of_clean") end ):SetIcon("icon16/cut.png")
	m:AddOption( "重置地图", function() RunConsoleCommand( "of_cleanup") end ):SetIcon("icon16/arrow_refresh.png")
	
	m:AddSpacer()
	
	--[[
	local marcr = m:AddSubMenu( "ARC放射状菜单*" )	   --ARC菜单

	marcr:SetDeleteSelf( false )	
	marcr:AddOption( "打开控制菜单", function() RunConsoleCommand( "ARC_RADIAL_CUSTOMIZE") end )
	
	
	
	
	local mnpc = m:AddSubMenu( "NPC外观随机化*" )	   --NPC菜单

	mnpc:SetDeleteSelf( false )
	mnpc:AddCVar( "禁用随机模型（不影响下面两个选项）", "npc_model_randomizer_chosen","1","0" )	
	mnpc:AddCVar( "允许随机皮肤", "npc_model_randomizer_skin_random","1","0" )	
	mnpc:AddCVar( "允许随机身体组件", "npc_model_randomizer_bodygroups_random","1","0" )
	mnpc:AddSpacer()
	mnpc:AddCVar( "对联合军士兵生效", "npc_model_randomizer_combine_s","1","0" )
	mnpc:AddCVar( "对市民生效", "npc_model_randomizer_citizen","1","0" )
	mnpc:AddCVar( "对国民护卫队生效", "npc_model_randomizer_metropolice","1","0" )	
	mnpc:AddSpacer()
	mnpc:AddOption( "打开控制菜单", function() RunConsoleCommand( "npc_model_randomizer_gui") end )	
	
	
	
	local mot = m:AddSubMenu( "其他插件支持*" )	   --其他插件支持

	mot:SetDeleteSelf( false )
		local motnb = mot:AddSubMenu( "NEXTBOTS 3.0" )	   --NEXTBOTS3.0

		motnb:SetDeleteSelf( false )
		motnb:AddCVar( "暂停所有NEXTBOT的活动", "nb_stop","1","0" )
		motnb:AddCVar( "无视所有目标", "nb_targetmethod","1","0" )	
		motnb:AddCVar( "无视玩家", "ai_ignoplayers","1","0" )	
		motnb:AddCVar( "允许开门", "nb_doordination","1","0" )
		motnb:AddCVar( "友军伤害", "nb_friendlyfire","1","0" )	
		motnb:AddCVar( "敌人靠近时后退", "nb_allow_backingup","1","0" )	
		motnb:AddCVar( "找掩体换弹", "nb_solder_findreloadspot","1","0" )	
		motnb:AddCVar( "死亡动画", "nb_death_animations","1","0" )	
	
	
	m:AddSpacer()
	]]--
	local mwar,mwarOption = m:AddSubMenu( "战役助手" )	   --战役菜单
	mwarOption:SetIcon( "icon16/bomb.png" )
	
	mwar:SetDeleteSelf( false )
	mwar:AddCVar( "无敌", "of_god","1","0" )
	mwar:AddSpacer()
	mwar:AddOption( "去除自己的武器", function() RunConsoleCommand( "of_removeallweapons") end ):SetIcon( "icon16/wand.png" )
	mwar:AddOption( "把现在的位置设为出生点", function() RunConsoleCommand( "of_saveasplayerspawn") end ):SetIcon( "icon16/flag_orange.png" )
	mwar:AddOption( "移除保存的出生点", function() RunConsoleCommand( "of_deleteplayerspawn") end ):SetIcon( "icon16/cross.png" )
	mwar:AddOption( "保存现在的位置", function() RunConsoleCommand( "of_teleportsave") end ):SetIcon( "icon16/vcard.png" )
	mwar:AddOption( "传送到保存的位置", function() RunConsoleCommand( "of_teleport") end ):SetIcon( "icon16/user_go.png" )
	mwar:AddOption( "传送到死亡的位置", function() RunConsoleCommand( "of_death") end ):SetIcon( "icon16/user_go.png" )
	mwar:AddOption( "传送到看着的位置", function() RunConsoleCommand( "of_teleporteyetrace") end ):SetIcon( "icon16/user_go.png" )
	mwar:AddSpacer()
	mwar:AddCVar( "战区空中滑行*", "vwarzone_enableskydive", "1", "0" )
	mwar:AddCVar( "战区降落伞*", "vwarzone_enableparachute", "1", "0" )
	mwar:AddSpacer()
	mwar:AddCVar( "增强联合军AI*", "kn_realistic_combine", "1", "0" )
	mwar:AddCVar( "NPC智能寻路*（与前者不兼容）", "z_npc_nav_enabled", "1", "0" )	
	mwar:AddSpacer()
	mwar:AddCVar( "NPC随机皮肤*", "npc_model_randomizer_skin_random","1","0" )	
	mwar:AddCVar( "NPC随机身体组件*", "npc_model_randomizer_bodygroups_random","1","0" )
	

	--local mmove = m:AddSubMenu( "移动方式*" ):SetIcon( "icon16/flag_orange.png" )	   --移动方式
	
	--mmove:SetDeleteSelf( false )
		
	--mmove:AddCVar( "战区空中滑行", "vwarzone_enableskydive", "1", "0" )
	--mmove:AddCVar( "战区降落伞", "vwarzone_enableparachute", "1", "0" )	
	
	
	local ma, maOption = m:AddSubMenu( "动画助手" )	   --动画菜单
	maOption:SetIcon( "icon16/film.png" )

	ma:SetDeleteSelf( false )
	ma:AddCVar( "渲染第一人称模型", "r_drawviewmodel", "1", "0" )
	--ma:AddOption( "一键隐藏第三人称", function() RunConsoleCommand( "of_hidethirdperson") end )	
	ma:AddCVar( "渲染第三人称模型", "of_thirdperson", "1", "0" )
	ma:AddCVar( "显示布娃娃实际碰撞", "vcollide_wireframe", "1", "0" )
	ma:AddCVar( "材质反射", "mat_specular", "1", "0" )
	ma:AddSpacer()
	ma:AddOption( "清理污渍", function() RunConsoleCommand( "r_cleardecals") end ):SetIcon("icon16/cut_red.png")
	ma:AddSpacer()
		local ms, msOption = ma:AddSubMenu("速度调整（需要作弊）")	--游戏速度菜单
		msOption:SetIcon( "icon16/clock.png" )
		ms:SetDeleteSelf( false )

		ms:AddOption( "正常速度", function() RunConsoleCommand( "host_timescale","1")  end )
		ms:AddOption( "速度*0.5", function() RunConsoleCommand( "host_timescale","0.5" )  end )
		ms:AddOption( "速度*0.25", function() RunConsoleCommand( "host_timescale","0.25" )  end )
		ms:AddOption( "速度*0.1", function() RunConsoleCommand( "host_timescale","0.1" )  end )
		
	
	
	local mm,mmOption = m:AddSubMenu( "地图制作" )	   --地图制作菜单
	mmOption:SetIcon( "icon16/map.png" )

	mm:SetDeleteSelf( false )

	mm:AddCVar( "线框模式", "mat_wireframe", "3", "0" )
	mm:AddCVar( "显示实时帧数", "cl_showfps", "1", "0" )
	mm:AddCVar( "显示地图实体与输入/输出*", "sv_drawmapio", "1", "0" )

	mm:AddSpacer()
	
	--mm:AddOption( "隐藏地图细节", function() RunConsoleCommand( "of_hide") end ):SetIcon( "icon16/world.png" )
	mm:AddCVar( "显示地图细节", "of_skybox", "1", "0" )
	mm:AddSpacer()
	
	mm:AddCVar( "全亮模式", "mat_fullbright", "1", "0" )

	    local mmhdr, mmhdrOption = mm:AddSubMenu( "HDR等级" )          --地图制作菜单的子菜单：高动态范围光照
		mmhdrOption:SetIcon( "icon16/rainbow.png" )
		mmhdr:SetDeleteSelf( false )
		
		mmhdr:AddOption( "没有HDR", function() RunConsoleCommand( "mat_hdr_level","0") end ):SetIcon( "icon16/weather_clouds.png" )
		mmhdr:AddOption( "只有LDR和Bloom", function() RunConsoleCommand( "mat_hdr_level","1") end ):SetIcon( "icon16/weather_cloudy.png" )
		mmhdr:AddOption( "完整的HDR和Bloom", function() RunConsoleCommand( "mat_hdr_level","2") end ):SetIcon( "icon16/weather_sun.png" )

	mm:AddSpacer()
	

	mm:AddCVar( "显示导航网格", "nav_edit", "1", "0" ):SetIcon( "icon16/chart_line.png" )
	mm:AddOption( "保存导航网格", function() RunConsoleCommand( "nav_save") end ):SetIcon( "icon16/disk.png" )
	mm:AddOption( "载入导航网格", function() RunConsoleCommand( "nav_load") end ):SetIcon( "icon16/chart_line_add.png" )
	mm:AddOption( "分析导航网格", function() RunConsoleCommand( "nav_analyze") end ):SetIcon( "icon16/chart_line_error.png" )
		local mmn, mmnOption = mm:AddSubMenu( "自动绘制导航网格" )          --地图制作菜单的子菜单：自动绘制路点
		mmnOption:SetIcon( "icon16/chart_line_edit.png" )

		mmn:SetDeleteSelf( false )
	
		mmn:AddOption( "普通绘制（标准方案）", function() RunConsoleCommand( "nav_generate") end ):SetIcon( "icon16/flag_blue.png" )
		mmn:AddOption( "快速绘制*（差强人意）", function() RunConsoleCommand( "nav_generate_cheap") end ):SetIcon( "icon16/flag_green.png" )
		mmn:AddOption( "高级绘制*（祝你好运）", function() RunConsoleCommand( "nav_generate_expanded") end ):SetIcon( "icon16/flag_red.png" )
	mm:AddOption( "自动合并导航网格*", function() RunConsoleCommand( "navmesh_globalmerge_auto") end ):SetIcon( "icon16/chart_line_link.png" )
	mm:AddOption( "构建立方体贴图", function() RunConsoleCommand( "buildcubemaps") end ):SetIcon( "icon16/contrast.png" )
	
	mm:AddSpacer()
	mm:AddOption( "显示俯视图参考线", function() RunConsoleCommand( "of_1024") end ):SetIcon( "icon16/anchor.png" )
	mm:AddOption( "2秒后无损截屏", function() RunConsoleCommand( "of_screenshot") end ):SetIcon( "icon16/camera.png" )
	
	
	local mdv, mdvOption = m:AddSubMenu( "开发工具" )	   --开发工具菜单
	mdvOption:SetIcon( "icon16/monitor.png" )

	mdv:SetDeleteSelf( false )
	mdv:AddOption( "重载模组" , function() RunConsoleCommand( "of_reload") end ):SetIcon( "icon16/arrow_refresh.png" )
	mdv:AddOption( "控制台列出绑键", function() RunConsoleCommand( "key_listboundkeys" )  end ):SetIcon( "icon16/application_xp_terminal.png" )
	mdv:AddCVar( "使用多核渲染", "Gmod_mcore_test", "1", "0" )

	m:AddSpacer()
	m:AddOption( "加血", function() RunConsoleCommand( "of_hpp") end ):SetIcon( "icon16/pill.png" )
	m:AddOption( "自杀", function() RunConsoleCommand( "kill") end ):SetIcon( "icon16/rosette.png" )

end)
