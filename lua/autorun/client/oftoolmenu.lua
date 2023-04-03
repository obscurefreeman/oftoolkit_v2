AddCSLuaFile()



local xx,yy=ScrW()/1920,ScrH()/1080
local xxp,yyp=800*xx-162,600*yy
local xxs,yys=xxp/638,yyp/600

surface.CreateFont("oftitle", {     --创建字体
    font = "Dream Han Sans CN",
    extended = false ,
    size = 40*xxs
})

surface.CreateFont("oftextlarge", {
    font = "Dream Han Sans CN W14",
    extended = false,
    size = 30*xxs
})

surface.CreateFont("oftext", {
    font = "Dream Han Sans CN W14",
    extended = false,
    size = 20*xxs
})

local faded_black = Color(0, 0, 0, 200) -- The color black but with 200 Alpha
local panel = Color(37, 17, 2, 105)
local oflistcolor = Color(200, 200, 200, 88)    --这玩意是左边列表框子的颜色
local ofbarcolor1 = Color(128, 0, 255, 190)    --这玩意是选项卡本来的颜色，点它会出现下拉菜单，我本来想把它们染成彩色的，但是这样太丑了
local ofbarcolor2 = Color(0, 157, 255, 190)
local ofbarcolor3 = Color(153, 212, 25, 190)
local ofbarcolor4 = Color(255, 0, 93, 190)
local ofbarcolor5 = Color(222, 215, 12, 190)
local ofbarcolorb1 = Color(255, 255, 255, 156)  --这个暂时没有用
local ofbarcolor = Color(0, 0, 0, 156)  --这个是现在选项卡的颜色
local blacktext = Color(0, 0, 0, 207)  --黑色文字（目前没有用到）
local whitetext = Color(255, 255, 255, 255)  --白色文字
local importanttextcolor = Color(255, 115, 0, 255)



--                                                                        我发现这玩意不会自动换行，超出边界会显示不出来
--                                                                        ！这里是文字的边界
--下面的这堆代码我套用了别人的代码模板，我看不懂，但我大受震撼，这一部分文字会被后面的一堆代码读取并显示到菜单上
local helpentries = {
    ["基本功能"] = [[
    
    本工具箱支持大多数常用功能，现在你可以仅在一个地方管理和控制游戏和画面
    普通Gmod玩家，玩战役图的博主，动画制作者，插件作者，
    都能快速在其中找到自己想要的功能。
    
    本工具箱的制作主旨是把大多数常用的重要功能集中在一起，
    给玩家提供一个方便快捷的管理界面。

    工具箱提供两种使用方式，如果你觉得使用DMenu太麻烦的话可以打开窗口
    （就是你现在眼前的窗口，可以通过C键菜单或Dmenu唤出）
    个人觉得用窗口比较方便，不过窗口目前还没完全开发好。以后还会有新功能加入
    而且这两个方法的功能是不统一的。

    工具箱会支持一些基本插件，其中包括我常用的插件和某些热门插件。
    当然。如果你不喜欢这些插件你也可以不订阅，这不是必须的！！

    我想做这样的快捷工具箱已经很久了，目前我还在不断完善它的代码。

    
    ]],
    ["使用须知"] = [[
    
    本插件暂且不支持多人联机。
    “重载模组”按钮点击后有一秒钟的延迟，
    这允许你在一秒内点击win键可以切出游戏，让游戏在后台载入。
    （这是人性化的设置，因为你可以切出去看B站，不用死盯着进度条了，
    Gmod载入时会有一段时间不能切出去）
    带有星号（*）的选项需要订阅第三方插件，这些插件不是必须订阅的。
    ]],
    ["关于插件"] = [[
    
    本插件的灵感来自与戈登走过去的工具箱。
    部分字体使用了可商用字体：梦源黑体，此字体可以自由传播、分享或嵌入。
    (不过目前字体导入后只有英文能显示为这个字体，具体情况还在研究)

    本工具箱的代码目前并不完善，我只能保证在单人模式中不会出问题。
    更多功能正在制作中。。。


    还有，记得去玩玩我做的地图！
    GMOD和CSGO都有噢！
    ]]
}












if of_menu then of_menu:Remove() end    --菜单主体
of_menu=nil 
concommand.Add("of_menu",function (ply)
    if of_menu then of_menu:Remove()end
    local of_menu = vgui.Create("DFrame")
    of_menu:SetSize(800*xx, 600*yy)
    of_menu:Center()
    of_menu:SetTitle("晦涩弗里曼的工具箱V2.1.1（暂不支持多人联机）")    --因为没搞网络相关的代码(≧∇≦)ﾉ
    of_menu:SetDraggable(true)
    of_menu:MakePopup()
    of_menu.Paint = function(self, w, h)
        -- Draws a rounded box with the color faded_black stored above.
        draw.RoundedBox(8, 0, 0, w, h, faded_black)
    end

    local ofleftbar = vgui.Create("DCategoryList", of_menu)
    ofleftbar:SetSize(150, 600*yy)
    ofleftbar:Dock(LEFT)
    ofleftbar:DockPadding(2, 2, 2, 2)
    ofleftbar.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, oflistcolor)
    end

    local ofmpanel = vgui.Create("DPanel", of_menu)
    ofmpanel:SetSize(800*xx-162, 600*yy)
    ofmpanel:Dock(RIGHT)
    ofmpanel:DockPadding(2, 2, 2, 8)
    ofmpanel.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, panel)
    end
    --[[
    local ofmpanel1 = vgui.Create("DPanel", of_menu)        --教科书式的失败代码
    ofmpanel1:SetSize(xxp/2, yyp/2)                         --创建了ofmpanel1后他们会挡住后面的按钮不让我按
    ofmpanel1:Dock(LEFT)
    ofmpanel1:DockPadding(2, 2, 2, 8)
    --ofmpanel1:SetDisabled
    ofmpanel1.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))
    end
    
    local ofmpanel2 = vgui.Create("DPanel", of_menu)
    ofmpanel2:SetSize(xxp/2, yyp/2)
    ofmpanel2:Dock(LEFT)
    ofmpanel2:DockPadding(2, 2, 2, 8)
    ofmpanel2.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
    end
    ]]--

    
--[[
    local ofmwellcome = vgui.Create("RichText", ofmpanel)     --欢迎界面(富文本测试)
    ofmwellcome:Dock(FILL)
    ofmwellcome:DockPadding(2, 2, 2, 2)
    ofmwellcome:AppendText("This \nRichText \nis \n")
]]--


    local ofmwellcome = vgui.Create("DLabel", ofmpanel)     --欢迎界面：这玩意会在玩家每次打开菜单时显示一个欢迎界面
    ofmwellcome:Dock(TOP) 
    ofmwellcome:SetSize(xxp, yyp/9) 
    ofmwellcome:DockPadding(8, 4, 8, 4)
    ofmwellcome:SetFont("oftitle")  --设置字体
    steamworks.RequestPlayerInfo( LocalPlayer():SteamID64() )
    ofmwellcome:SetText("欢迎" .. steamworks.GetPlayerName( LocalPlayer():SteamID64() ) .. "!")
    ofmwellcome:SetTextColor(importanttextcolor)
    --[[
    ofmwellcome.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 0))   --反正你也看不见
        surface.SetFont("oftitle")
        surface.SetTextColor(255,255,255)
        steamworks.RequestPlayerInfo( LocalPlayer():SteamID64() )   --读取玩家姓名（如果玩家姓名过长会有一部分显示不出来）
        surface.DrawText("欢迎" .. steamworks.GetPlayerName( LocalPlayer():SteamID64() ) .. "!","\n","祝你玩得愉快~","\n","q(≧▽≦q)")    --我不知道为什么，文字换行会导致显示不出来
    end     --这是为啥，难道DLabel只有这么小？
    ]]--
    local ofmwellcome2 = vgui.Create("DLabel", ofmpanel)
    ofmwellcome2:Dock(TOP)     
    ofmwellcome2:SetSize(xxp, yyp/9) 
    ofmwellcome2:DockPadding(8, 4, 8, 8)
    ofmwellcome2:SetFont("oftitle") 
    ofmwellcome2:SetText("祝你玩得愉快~q(≧▽≦q)")
    ofmwellcome2:SetTextColor(whitetext)

    local ofmwellcome3 = vgui.Create("DLabel", ofmpanel)
    ofmwellcome3:Dock(TOP)     
    ofmwellcome3:SetSize(xxp, yyp/5) 
    ofmwellcome3:DockPadding(8, 4, 8, 8)
    ofmwellcome3:SetFont("oftextlarge") 
    ofmwellcome3:SetText("作为工具箱，它包含了大多数我能想到的实用功能。\n我指的是，如果你有什么有趣的想法，请在B站联系我。\n你的名字会被列出在贡献者名单里！")
    ofmwellcome3:SetTextColor(whitetext)


    

    local ofmwellcomenews = vgui.Create("DLabel", ofmpanel)
    ofmwellcomenews:Dock(TOP)     
    ofmwellcomenews:SetSize(xxp, yyp/9) 
    ofmwellcomenews:DockPadding(8, 4, 8, 4)
    ofmwellcomenews:SetFont("oftextlarge") 
    ofmwellcomenews:SetText("新闻！")
    ofmwellcomenews:SetTextColor(importanttextcolor)

    local ofmwellcomeud = vgui.Create( "RichText", ofmpanel )
    ofmwellcomeud:Dock( TOP )
    ofmwellcomeud:DockPadding(8, 4, 8, 4)
    ofmwellcomeud:SetSize(xxp, yyp/3) 
    ofmwellcomeud:InsertColorChange( 255, 255, 255, 255 )
    ofmwellcomeud:AppendText("2023.3.30 \n晦弗工具箱V2代码基本定型，不过其主要功能尚且和一代出入不多，\n我准备慢慢完善并加入一些让人眼前一亮的新功能\n")
    ofmwellcomeud:AppendText("2023.3.25 \n完善了Dmenu上的图标，着手制作工具箱窗口\n")
    ofmwellcomeud:AppendText("2023.3.11 \n《酒店突袭：机场解围》发布\n")
    ofmwellcomeud:AppendText("2023.2.18 \n做了一些ARC9的美化模组\n")
    ofmwellcomeud:AppendText("2023.2.13 \n晦弗工具箱V1推出\n")
    ofmwellcomeud:AppendText("2023.2.3 \n拉姆达用户界面发布，几天后上了创意工坊主页，\n这是我迄今最受欢迎的插件了！感谢大家的支持\n")
    ofmwellcomeud:AppendText("2023.1.26 \n【装甲核心边境设施】历经多次更新，地图迎来定稿版本。\n美中不足的是地图中有些BUG依然存在。比如说有一个箱子的模型显示不出。\n其原因为地图中模型实在太多，并且编译地图的时间已经从刚开始的两个半小时变为惊人的一整晚！\n一个下午的时间还不够它编译一半。\n")
    ofmwellcomeud:AppendText("2023.1.16 \n【装甲核心边境设施】推出黎明版本\n")
    ofmwellcomeud:AppendText("2023.1.2 \nCSGO大逃杀地图【装甲核心边境设施】发布\n")
    ofmwellcomeud:AppendText("2022.7.29 \n我抢到了S&box的名额，做了一些起源2的测试图，效果一般。给还没发布的游戏做地图效果怪怪的\n")
    ofmwellcomeud:AppendText("2022.7.27 \n捣鼓了一下起源2引擎，做了一些测试地图，起源2用起来不太顺手\n")
    ofmwellcomeud:AppendText("2022.7.18 \n我发布了一张关于自己学校的Gmod地图，这是我的处女作（之前的地图是测试用的，不算）\n")
    
    --[[
    ofmwellcome2.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 0))   --反正你也看不见
        surface.SetFont("oftitle")
        surface.SetTextColor(255,255,255)
        steamworks.RequestPlayerInfo( LocalPlayer():SteamID64() )   --读取玩家姓名（如果玩家姓名过长会有一部分显示不出来）
        surface.DrawText("祝你玩得愉快~q(≧▽≦q)")    --我不知道为什么，文字换行会导致显示不出来
    end     --这是为啥，难道DLabel只有这么小？
    ]]--
    --[[
    local ofmwellcomehappy = vgui.Create("DLabel", ofmpanel)
    ofmwellcomehappy:Dock(FILL)
    ofmwellcomehappy:DockPadding(0, 0, 0, 0)
    ofmwellcomehappy:SetFont("oftitle")
    ofmwellcomehappy:SetText("")

    
    ofmwellcome.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 0))
        surface.SetFont("oftitle")
        surface.SetTextColor(255,255,255)
        steamworks.RequestPlayerInfo( LocalPlayer():SteamID64() )
        surface.DrawText("q(≧▽≦q)")
    end
    ]]--
    local function ofm_single()
        ofmpanel:Clear()
        --ofmpanel1:Clear()
        --ofmpanel2:Clear()
        --ofmpanel1:SetDisabled()
        --ofmpanel2:SetDisabled()
    end
    local function ofm_clear()
        ofmpanel:Clear()
        --surface.PlaySound("ambient/water/drip"..math.random(1, 4)..".wav")
        --ofmpanel1:Clear()
        --ofmpanel2:Clear()
        --[[
        local ofmpanel1 = vgui.Create("DPanel", of_menu)
        ofmpanel1:SetSize(xxp/2, yyp/2)
        ofmpanel1:Dock(LEFT)
        ofmpanel1:DockPadding(2, 2, 2, 8)
        ofmpanel1.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))       --我发现如果不把ofmpanel1和ofmwarmvcbgod放在同一个function里，ofmwarmvcbgod会检测不到它
        end
        
        local ofmpanel2 = vgui.Create("DPanel", of_menu)
        ofmpanel2:SetSize(xxp/2, yyp/2)
        ofmpanel2:Dock(LEFT)
        ofmpanel2:DockPadding(2, 2, 2, 8)
        ofmpanel2.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
        end
        ]]--
    end

    


    local ofmwar = ofleftbar:Add("战役助手")
    ofmwar.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ofbarcolor)
    end

    
    local function ofm_warmv()
        local ofmpanel1 = vgui.Create("DPanel", ofmpanel)        --前面我说ofmpanel1是教科书式的失败代码，实际上我还挺舍不得的，这段代码打了我半天
        ofmpanel1:SetSize(xxp/2, yyp/2)                         --把ofmpanel1和ofmwarmvcbgod放在同一个function里就不会报错了，我也不知道为什么
        ofmpanel1:Dock(LEFT)                                    --不过这样子让代码看起来很复杂，它已经看起来很丑了！
        ofmpanel1:DockPadding(2, 2, 2, 8)
        --ofmpanel1:SetDisabled
        ofmpanel1.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))
        end
        
        local ofmpanel2 = vgui.Create("DPanel", ofmpanel)
        ofmpanel2:SetSize(xxp/2, yyp/2)
        ofmpanel2:Dock(LEFT)
        ofmpanel2:DockPadding(2, 2, 2, 8)
        ofmpanel2.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
        end
        
        local ofmwarmv1 = vgui.Create("DLabel", ofmpanel1)
        ofmwarmv1:Dock(TOP)
        ofmwarmv1:DockMargin(2, 8, 2, 8)
        ofmwarmv1:SetText("玩家相关")
        ofmwarmv1:SetFont("oftext")
        ofmwarmv1:SetTextColor(importanttextcolor)

        local ofmwarmvcbgod = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarmvcbgod:Dock(TOP)
        ofmwarmvcbgod:DockMargin(2, 4, 2, 4)					
	    ofmwarmvcbgod:SetText("无敌")
        ofmwarmvcbgod:SetTextColor(whitetext)
        ofmwarmvcbgod:SetFont("oftext")				
	    ofmwarmvcbgod:SetConVar("of_god")										
	    ofmwarmvcbgod:SizeToContents()

        local ofmwarmvcballowweaponsinvehicle = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarmvcballowweaponsinvehicle:Dock(TOP)
        ofmwarmvcballowweaponsinvehicle:DockMargin(2, 4, 2, 4)					
	    ofmwarmvcballowweaponsinvehicle:SetText("允许在车内使用武器")
        ofmwarmvcballowweaponsinvehicle:SetTextColor(whitetext)
        ofmwarmvcballowweaponsinvehicle:SetFont("oftext")				
	    ofmwarmvcballowweaponsinvehicle:SetConVar("of_allowweaponsinvehicle")										
	    ofmwarmvcballowweaponsinvehicle:SizeToContents()

        local ofmwarmv1_1 = vgui.Create("DLabel", ofmpanel1)
        ofmwarmv1_1:Dock(TOP)
        ofmwarmv1_1:DockMargin(2, 8, 2, 8)
        ofmwarmv1_1:SetText("移动方式")
        ofmwarmv1_1:SetFont("oftext")
        ofmwarmv1_1:SetTextColor(importanttextcolor)


        local ofmwarmvcbskydive = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarmvcbskydive:Dock(TOP)
        ofmwarmvcbskydive:DockMargin(2, 4, 2, 4)						
	    ofmwarmvcbskydive:SetText("战区空中滑行*")
        ofmwarmvcbskydive:SetTextColor(whitetext)
        ofmwarmvcbskydive:SetFont("oftext")				
	    ofmwarmvcbskydive:SetConVar("vwarzone_enableskydive")										
	    ofmwarmvcbskydive:SizeToContents()

        local ofmwarmvcbparachute = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarmvcbparachute:Dock(TOP)
        ofmwarmvcbparachute:DockMargin(2, 4, 2, 4)						
	    ofmwarmvcbparachute:SetText("战区降落伞*")
        ofmwarmvcbparachute:SetTextColor(whitetext)	
        ofmwarmvcbparachute:SetFont("oftext")			
	    ofmwarmvcbparachute:SetConVar("vwarzone_enableparachute")										
	    ofmwarmvcbparachute:SizeToContents()

        local ofmwarmvcbarc = vgui.Create("DButton", ofmpanel1)
        ofmwarmvcbarc:SetText("ARC放射菜单设置")
        ofmwarmvcbarc:Dock(TOP)
        ofmwarmvcbarc:DockMargin(2, 4, 2, 4)
        ofmwarmvcbarc.DoClick = function()
            RunConsoleCommand( "ARC_RADIAL_CUSTOMIZE")
        end


        local ofmwarmv2 = vgui.Create("DLabel", ofmpanel2)
        ofmwarmv2:Dock(TOP)
        ofmwarmv2:DockMargin(2, 8, 2, 8)
        ofmwarmv2:SetText("敌人设置")
        ofmwarmv2:SetFont("oftext")
        ofmwarmv2:SetTextColor(importanttextcolor)

        local ofmwarmvcbrc = ofmpanel2:Add( "DCheckBoxLabel" )
	    ofmwarmvcbrc:Dock(TOP)
        ofmwarmvcbrc:DockMargin(2, 4, 2, 4)						
	    ofmwarmvcbrc:SetText("F.E.A.R AI*")
        ofmwarmvcbrc:SetTextColor(whitetext)
        ofmwarmvcbrc:SetFont("oftext")				
	    ofmwarmvcbrc:SetConVar("kn_realistic_combine")										
	    ofmwarmvcbrc:SizeToContents()

        local ofmwarmvcbnn = ofmpanel2:Add( "DCheckBoxLabel" )
	    ofmwarmvcbnn:Dock(TOP)
        ofmwarmvcbnn:DockMargin(2, 4, 2, 4)					
	    ofmwarmvcbnn:SetText("NPC智能寻路*")
        ofmwarmvcbnn:SetTextColor(whitetext)
        ofmwarmvcbnn:SetFont("oftext")				
	    ofmwarmvcbnn:SetConVar("z_npc_nav_enabled")										
	    ofmwarmvcbnn:SizeToContents()

        local ofmwarmvcbrsr = ofmpanel2:Add( "DCheckBoxLabel" )
	    ofmwarmvcbrsr:Dock(TOP)
        ofmwarmvcbrsr:DockMargin(2, 4, 2, 4)						
	    ofmwarmvcbrsr:SetText("NPC随机皮肤*")
        ofmwarmvcbrsr:SetTextColor(whitetext)
        ofmwarmvcbrsr:SetFont("oftext")			
	    ofmwarmvcbrsr:SetConVar("npc_model_randomizer_skin_random")										
	    ofmwarmvcbrsr:SizeToContents()

        local ofmwarmvcbrbr = ofmpanel2:Add( "DCheckBoxLabel" )
	    ofmwarmvcbrbr:Dock(TOP)
        ofmwarmvcbrbr:DockMargin(2, 4, 2, 4)						
	    ofmwarmvcbrbr:SetText("NPC随机身体组件*")
        ofmwarmvcbrbr:SetTextColor(whitetext)
        ofmwarmvcbrbr:SetFont("oftext")					
	    ofmwarmvcbrbr:SetConVar("npc_model_randomizer_bodygroups_random")										
	    ofmwarmvcbrbr:SizeToContents()

        

    end


    local ofmwarmv = vgui.Create("DButton", ofmwar)
    ofmwarmv:SetText("游戏体验")
    ofmwarmv:Dock(TOP)
    ofmwarmv:DockMargin(0, 0, 0, 0)
    ofmwarmv.DoClick = function()
        ofm_clear()
        ofm_warmv()
    end

    local function ofm_warlc()
        local ofmpanel1 = vgui.Create("DPanel", ofmpanel)
        ofmpanel1:SetSize(xxp/2, yyp/2)
        ofmpanel1:Dock(LEFT) 
        ofmpanel1:DockPadding(2, 2, 2, 8)
        --ofmpanel1:SetDisabled
        ofmpanel1.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))
        end
        
        local ofmpanel2 = vgui.Create("DPanel", ofmpanel)
        ofmpanel2:SetSize(xxp/2, yyp/2)
        ofmpanel2:Dock(LEFT)
        ofmpanel2:DockPadding(2, 2, 2, 8)
        ofmpanel2.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
        end

        local ofmwarlct1 = vgui.Create("DLabel", ofmpanel1)
        ofmwarlct1:Dock(TOP)
        ofmwarlct1:DockMargin(2, 8, 2, 8)
        ofmwarlct1:SetText("快捷传送")
        ofmwarlct1:SetFont("oftext")
        ofmwarlct1:SetTextColor(importanttextcolor)

        local ofmwarlcsetasrespawn = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarlcsetasrespawn:Dock(TOP)
        ofmwarlcsetasrespawn:DockMargin(2, 4, 2, 4)						
	    ofmwarlcsetasrespawn:SetText("自动把死亡的位置设置为出生点")
        ofmwarlcsetasrespawn:SetTextColor(whitetext)
        ofmwarlcsetasrespawn:SetFont("oftext")			
	    ofmwarlcsetasrespawn:SetConVar("of_setasrespawn")										
	    ofmwarlcsetasrespawn:SizeToContents()

        local ofmwarlcspawngod = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarlcspawngod:Dock(TOP)
        ofmwarlcspawngod:DockMargin(2, 4, 2, 4)						
	    ofmwarlcspawngod:SetText("重生后无敌三秒")
        ofmwarlcspawngod:SetTextColor(whitetext)
        ofmwarlcspawngod:SetFont("oftext")			
	    ofmwarlcspawngod:SetConVar("of_spawngod")										
	    ofmwarlcspawngod:SizeToContents()

        local ofmwarlcexplodafterdeath = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarlcexplodafterdeath:Dock(TOP)
        ofmwarlcexplodafterdeath:DockMargin(2, 4, 2, 4)						
	    ofmwarlcexplodafterdeath:SetText("死后原地爆炸")
        ofmwarlcexplodafterdeath:SetTextColor(whitetext)
        ofmwarlcexplodafterdeath:SetFont("oftext")			
	    ofmwarlcexplodafterdeath:SetConVar("of_explodafterdeath")										
	    ofmwarlcexplodafterdeath:SizeToContents()
        
        

        local ofmwarlcsps = vgui.Create("DButton", ofmpanel1)
        ofmwarlcsps:SetText("把现在的位置设为出生点")
        ofmwarlcsps:Dock(TOP)
        ofmwarlcsps:DockMargin(2, 8, 2, 8)
        ofmwarlcsps:SetIcon( "icon16/flag_orange.png" )
        ofmwarlcsps.DoClick = function()
            RunConsoleCommand( "of_saveasplayerspawn")
        end

        local ofmwarlcdps = vgui.Create("DButton", ofmpanel1)
        ofmwarlcdps:SetText("移除保存的出生点")
        ofmwarlcdps:Dock(TOP)
        ofmwarlcdps:DockMargin(2, 8, 2, 8)
        ofmwarlcdps:SetIcon( "icon16/cross.png" )
        ofmwarlcdps.DoClick = function()
            RunConsoleCommand( "of_deleteplayerspawn")
        end

        local ofmwarlcdt = vgui.Create("DButton", ofmpanel1)
        ofmwarlcdt:SetText("传送到死亡的位置")
        ofmwarlcdt:Dock(TOP)
        ofmwarlcdt:DockMargin(2, 8, 2, 8)
        ofmwarlcdt:SetIcon( "icon16/user_go.png" )
        ofmwarlcdt.DoClick = function()
            RunConsoleCommand( "of_death")
        end

        local ofmwarlctps = vgui.Create("DButton", ofmpanel1)
        ofmwarlctps:SetText("保存现在的位置")
        ofmwarlctps:Dock(TOP)
        ofmwarlctps:DockMargin(2, 8, 2, 8)
        ofmwarlctps:SetIcon( "icon16/vcard.png" )
        ofmwarlctps.DoClick = function()
            RunConsoleCommand( "of_teleportsave")
        end

        local ofmwarlctp = vgui.Create("DButton", ofmpanel1)
        ofmwarlctp:SetText("传送到保存的位置")
        ofmwarlctp:Dock(TOP)
        ofmwarlctp:DockMargin(2, 8, 2, 8)
        ofmwarlctp:SetIcon( "icon16/user_go.png" )
        ofmwarlctp.DoClick = function()
            RunConsoleCommand( "of_teleport")
        end
        --[[
        mwar:AddOption( "把现在的位置设为出生点", function() RunConsoleCommand( "of_saveasplayerspawn") end ):SetIcon( "icon16/flag_orange.png" )
        mwar:AddOption( "移除保存的出生点", function() RunConsoleCommand( "of_deleteplayerspawn") end ):SetIcon( "icon16/cross.png" )
        mwar:AddOption( "保存现在的位置", function() RunConsoleCommand( "of_teleportsave") end ):SetIcon( "icon16/vcard.png" )
        mwar:AddOption( "传送到保存的位置", function() RunConsoleCommand( "of_teleport") end ):SetIcon( "icon16/user_go.png" )
        mwar:AddOption( "传送到死亡的位置", function() RunConsoleCommand( "of_death") end ):SetIcon( "icon16/user_go.png" )
        mwar:AddOption( "传送到看着的位置", function() RunConsoleCommand( "of_teleporteyetrace") end ):SetIcon( "icon16/user_go.png" )
        mwar:AddSpacer()
        ]]--
    end




    local ofmwarlc = vgui.Create("DButton", ofmwar)
    ofmwarlc:SetText("位置保存")
    ofmwarlc:Dock(TOP)
    ofmwarlc:DockMargin(0, 0, 0, 0)
    ofmwarlc.DoClick = function()
        ofm_clear()
        ofm_warlc()
    end

    local ofma = ofleftbar:Add("动画助手")
    ofma.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ofbarcolor)
    end

    local function ofm_mamd()
        local ofmpanel1 = vgui.Create("DPanel", ofmpanel)
        ofmpanel1:SetSize(xxp/2, yyp/2)
        ofmpanel1:Dock(LEFT) 
        ofmpanel1:DockPadding(2, 2, 2, 8)
        --ofmpanel1:SetDisabled
        ofmpanel1.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))
        end
        
        local ofmpanel2 = vgui.Create("DPanel", ofmpanel)
        ofmpanel2:SetSize(xxp/2, yyp/2)
        ofmpanel2:Dock(LEFT)
        ofmpanel2:DockPadding(2, 2, 2, 8)
        ofmpanel2.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
        end

        local ofmmamddv = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmamddv:Dock(TOP)
        ofmmamddv:DockMargin(2, 4, 2, 4)					
	    ofmmamddv:SetText("渲染第一人称模型")
        ofmmamddv:SetTextColor(whitetext)
        ofmmamddv:SetFont("oftext")				
	    ofmmamddv:SetConVar("r_drawviewmodel")									
	    ofmmamddv:SizeToContents()

        local ofmmamdtp = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmamdtp:Dock(TOP)
        ofmmamdtp:DockMargin(2, 4, 2, 4)					
	    ofmmamdtp:SetText("渲染第三人称模型")
        ofmmamdtp:SetTextColor(whitetext)
        ofmmamdtp:SetFont("oftext")				
	    ofmmamdtp:SetConVar("of_thirdperson")									
	    ofmmamdtp:SizeToContents()

        local ofmmamdvw = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmamdvw:Dock(TOP)
        ofmmamdvw:DockMargin(2, 4, 2, 4)					
	    ofmmamdvw:SetText("显示布娃娃实际碰撞")
        ofmmamdvw:SetTextColor(whitetext)
        ofmmamdvw:SetFont("oftext")				
	    ofmmamdvw:SetConVar("vcollide_wireframe")									
	    ofmmamdvw:SizeToContents()

        local ofmmamdms = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmamdms:Dock(TOP)
        ofmmamdms:DockMargin(2, 4, 2, 4)					
	    ofmmamdms:SetText("材质反射（会卡）")
        ofmmamdms:SetTextColor(whitetext)
        ofmmamdms:SetFont("oftext")				
	    ofmmamdms:SetConVar("mat_specular")									
	    ofmmamdms:SizeToContents()

    end



    local ofmmamd = vgui.Create("DButton", ofma)
    ofmmamd:SetText("模型显示")
    ofmmamd:Dock(TOP)
    ofmmamd:DockMargin(0, 0, 0, 0)
    ofmmamd.DoClick = function()
        ofm_clear()
        ofm_mamd()
    end

    local ofmm = ofleftbar:Add("地图制作")
    ofmm.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ofbarcolor)
    end

    local function ofm_mmdb()
        local ofmpanel1 = vgui.Create("DPanel", ofmpanel)
        ofmpanel1:SetSize(xxp/2, yyp/2)
        ofmpanel1:Dock(LEFT) 
        ofmpanel1:DockPadding(2, 2, 2, 8)
        --ofmpanel1:SetDisabled
        ofmpanel1.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))
        end
        
        local ofmpanel2 = vgui.Create("DPanel", ofmpanel)
        ofmpanel2:SetSize(xxp/2, yyp/2)
        ofmpanel2:Dock(LEFT)
        ofmpanel2:DockPadding(2, 2, 2, 8)
        ofmpanel2.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
        end

        local ofmmmdbio = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbio:Dock(TOP)
        ofmmmdbio:DockMargin(2, 4, 2, 4)					
	    ofmmmdbio:SetText("显示地图实体与输入/输出*")
        ofmmmdbio:SetTextColor(whitetext)
        ofmmmdbio:SetFont("oftext")				
	    ofmmmdbio:SetConVar("sv_drawmapio")									
	    ofmmmdbio:SizeToContents()
        
        local ofmmmdbskybox = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbskybox:Dock(TOP)
        ofmmmdbskybox:DockMargin(2, 4, 2, 4)					
	    ofmmmdbskybox:SetText("显示地图细节")
        ofmmmdbskybox:SetTextColor(whitetext)
        ofmmmdbskybox:SetFont("oftext")				
	    ofmmmdbskybox:SetConVar("of_skybox")									
	    ofmmmdbskybox:SizeToContents()

        local ofmmmdbmf = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbmf:Dock(TOP)
        ofmmmdbmf:DockMargin(2, 4, 2, 4)					
	    ofmmmdbmf:SetText("全亮模式")
        ofmmmdbmf:SetTextColor(whitetext)
        ofmmmdbmf:SetFont("oftext")				
	    ofmmmdbmf:SetConVar("mat_fullbright")									
	    ofmmmdbmf:SizeToContents()
        
--[[
        ma:AddCVar( "渲染第一人称模型", "r_drawviewmodel", "1", "0" )
        ma:AddOption( "一键隐藏第三人称", function() RunConsoleCommand( "of_hidethirdperson") end )	
        ma:AddCVar( "显示布娃娃实际碰撞", "vcollide_wireframe", "1", "0" )
        ma:AddCVar( "材质反射", "mat_specular", "1", "0" )
        ma:AddSpacer()
        ma:AddOption( "清理污渍", function() RunConsoleCommand( "r_cleardecals") end ):SetIcon("icon16/cut_red.png")

]]--


    end

    local ofmmmdb = vgui.Create("DButton", ofmm)
    ofmmmdb:SetText("地图概述")
    ofmmmdb:Dock(TOP)
    ofmmmdb:DockMargin(0, 0, 0, 0)
    ofmmmdb.DoClick = function()
        ofm_clear()
        ofm_mmdb()
    end





    local function ofm_mmnm()
        local ofmpanel1 = vgui.Create("DPanel", ofmpanel)
        ofmpanel1:SetSize(xxp/2, yyp/2)
        ofmpanel1:Dock(LEFT) 
        ofmpanel1:DockPadding(2, 2, 2, 8)
        --ofmpanel1:SetDisabled
        ofmpanel1.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 153, 0))
        end
        
        local ofmpanel2 = vgui.Create("DPanel", ofmpanel)
        ofmpanel2:SetSize(xxp/2, yyp/2)
        ofmpanel2:Dock(LEFT)
        ofmpanel2:DockPadding(2, 2, 2, 8)
        ofmpanel2.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 30, 255, 0))
        end
        
        local ofmmmnmed = vgui.Create("DLabel", ofmpanel1)
        ofmmmnmed:Dock(TOP)
        ofmmmnmed:DockMargin(2, 8, 2, 8)
        ofmmmnmed:SetText("手动编辑")
        ofmmmnmed:SetFont("oftext")
        ofmmmnmed:SetTextColor(importanttextcolor)

        local ofmmmnmeded = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmnmeded:Dock(TOP)
        ofmmmnmeded:DockMargin(2, 8, 2, 8)					
	    ofmmmnmeded:SetText("进入编辑模式")
        ofmmmnmeded:SetTextColor(whitetext)
        ofmmmnmeded:SetFont("oftext")				
	    ofmmmnmeded:SetConVar("nav_edit")									
	    ofmmmnmeded:SizeToContents()

        local ofmmmnmedsv = vgui.Create("DButton", ofmpanel1)
        ofmmmnmedsv:SetText("保存导航网格")
        ofmmmnmedsv:Dock(TOP)
        ofmmmnmedsv:DockMargin(2, 8, 2, 8)
        ofmmmnmedsv:SetIcon( "icon16/disk.png" )
        ofmmmnmedsv.DoClick = function()
            RunConsoleCommand( "nav_save")
        end

        local ofmmmnmedld = vgui.Create("DButton", ofmpanel1)
        ofmmmnmedld:SetText("加载导航网格")
        ofmmmnmedld:Dock(TOP)
        ofmmmnmedld:DockMargin(2, 8, 2, 8)
        ofmmmnmedld:SetIcon( "icon16/chart_line_add.png" )
        ofmmmnmedld.DoClick = function()
            RunConsoleCommand( "nav_load")
        end

        local ofmmmnmedan = vgui.Create("DButton", ofmpanel1)
        ofmmmnmedan:SetText("分析导航网格")
        ofmmmnmedan:Dock(TOP)
        ofmmmnmedan:DockMargin(2, 8, 2, 8)
        ofmmmnmedan:SetIcon( "icon16/chart_line_error.png" )
        ofmmmnmedan.DoClick = function()
            RunConsoleCommand( "nav_analyze")
        end

        local ofmmmnmedt = vgui.Create("DLabel", ofmpanel1)
        ofmmmnmedt:Dock(TOP)
        ofmmmnmedt:DockMargin(2, 8, 2, 4)
        ofmmmnmedt:SetText("非战斗人员请撤离，尤其不要动右边的按钮")
        ofmmmnmedt:SetFont("oftext")
        ofmmmnmedt:SetTextColor(whitetext)

        local ofmmmnmedt2 = vgui.Create("DLabel", ofmpanel1)
        ofmmmnmedt2:Dock(TOP)
        ofmmmnmedt2:DockMargin(2, 4, 2, 4)
        ofmmmnmedt2:SetText("你不会已经按了吧！")
        ofmmmnmedt2:SetFont("oftext")
        ofmmmnmedt2:SetTextColor(whitetext)




        local ofmmmnmat = vgui.Create("DLabel", ofmpanel2)
        ofmmmnmat:Dock(TOP)
        ofmmmnmat:DockMargin(2, 8, 2, 8)
        ofmmmnmat:SetText("快速加工")
        ofmmmnmat:SetFont("oftext")
        ofmmmnmat:SetTextColor(importanttextcolor)

        

        local ofmmmnmedatng = vgui.Create("DButton", ofmpanel2)
        ofmmmnmedatng:SetText("普通绘制")
        ofmmmnmedatng:Dock(TOP)
        ofmmmnmedatng:DockMargin(2, 8, 2, 8)
        ofmmmnmedatng:SetIcon( "icon16/flag_blue.png" )
        ofmmmnmedatng.DoClick = function()
            RunConsoleCommand( "nav_generate")
        end

        local ofmmmnmedatngt = vgui.Create("DLabel", ofmpanel2)
        ofmmmnmedatngt:Dock(TOP)
        ofmmmnmedatngt:DockMargin(2, 4, 2, 4)
        ofmmmnmedatngt:SetText("自动绘制导航网格，不需要插件")
        ofmmmnmedatngt:SetFont("oftext")
        ofmmmnmedatngt:SetTextColor(whitetext)



        local ofmmmnmedatngc = vgui.Create("DButton", ofmpanel2)
        ofmmmnmedatngc:SetText("快速绘制*")
        ofmmmnmedatngc:Dock(TOP)
        ofmmmnmedatngc:DockMargin(2, 8, 2, 8)
        ofmmmnmedatngc:SetIcon( "icon16/flag_green.png" )
        ofmmmnmedatngc.DoClick = function()
            RunConsoleCommand( "nav_generate_cheap")
        end

        local ofmmmnmedatngct = vgui.Create("DLabel", ofmpanel2)
        ofmmmnmedatngct:Dock(TOP)
        ofmmmnmedatngct:DockMargin(2, 4, 2, 4)
        ofmmmnmedatngct:SetText("快速廉价的绘制方法，但是文件可能会很大")
        ofmmmnmedatngct:SetFont("oftext")
        ofmmmnmedatngct:SetTextColor(whitetext)


        local ofmmmnmedatnge = vgui.Create("DButton", ofmpanel2)
        ofmmmnmedatnge:SetText("高级绘制*")
        ofmmmnmedatnge:Dock(TOP)
        ofmmmnmedatnge:DockMargin(2, 8, 2, 8)
        ofmmmnmedatnge:SetIcon( "icon16/flag_red.png" )
        ofmmmnmedatnge.DoClick = function()
            RunConsoleCommand( "nav_generate_expanded")
        end

        local ofmmmnmedatnget = vgui.Create("DLabel", ofmpanel2)
        ofmmmnmedatnget:Dock(TOP)
        ofmmmnmedatnget:DockMargin(2, 4, 2, 4)
        ofmmmnmedatnget:SetText("昂贵且高效的绘制方法")
        ofmmmnmedatnget:SetFont("oftext")
        ofmmmnmedatnget:SetTextColor(whitetext)

        local ofmmmnmedatnga = vgui.Create("DButton", ofmpanel2)
        ofmmmnmedatnga:SetText("自动合并导航网格*")
        ofmmmnmedatnga:Dock(TOP)
        ofmmmnmedatnga:DockMargin(2, 8, 2, 8)
        ofmmmnmedatnga:SetIcon( "icon16/chart_line_link.png" )
        ofmmmnmedatnga.DoClick = function()
            RunConsoleCommand( "navmesh_globalmerge_auto")
        end

        local ofmmmnmedatngat = vgui.Create("DLabel", ofmpanel2)
        ofmmmnmedatngat:Dock(TOP)
        ofmmmnmedatngat:DockMargin(2, 4, 2, 4)
        ofmmmnmedatngat:SetText("智能合并和分析导航网格，优化地图")
        ofmmmnmedatngat:SetFont("oftext")
        ofmmmnmedatngat:SetTextColor(whitetext)

        local ofmmmnmedatbc = vgui.Create("DButton", ofmpanel2)
        ofmmmnmedatbc:SetText("构建立方体贴图*")
        ofmmmnmedatbc:Dock(TOP)
        ofmmmnmedatbc:DockMargin(2, 8, 2, 8)
        ofmmmnmedatbc:SetIcon( "icon16/contrast.png" )
        ofmmmnmedatbc.DoClick = function()
            RunConsoleCommand( "buildcubemaps")
        end

        local ofmmmnmedatngbct = vgui.Create("DLabel", ofmpanel2)
        ofmmmnmedatngbct:Dock(TOP)
        ofmmmnmedatngbct:DockMargin(2, 4, 2, 4)
        ofmmmnmedatngbct:SetText("额。。。如果有的话")
        ofmmmnmedatngbct:SetFont("oftext")
        ofmmmnmedatngbct:SetTextColor(whitetext)
    end




--[[
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
]]--

    local ofmmmnm = vgui.Create("DButton", ofmm)
    ofmmmnm:SetText("收尾工作")
    ofmmmnm:Dock(TOP)
    ofmmmnm:DockMargin(0, 0, 0, 0)
    ofmmmnm.DoClick = function()
        ofm_clear()
        ofm_mmnm()
    end









    local ofmdv = ofleftbar:Add("开发工具")
    ofmdv.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ofbarcolor)
    end

    local function ofm_dvip()
        local ofmdviprl = vgui.Create("DButton", ofmpanel)
        ofmdviprl:SetText("重载模组")
        ofmdviprl:Dock(TOP)
        ofmdviprl:DockMargin(2, 8, 2, 8)
        ofmdviprl.DoClick = function()
            timer.Simple( 1, function() 
                RunConsoleCommand( "reload" ) 
            end )
        end

        ofmdviprl.DoRightClick = function()
            timer.Simple( 5, function() 
                RunConsoleCommand( "reload" ) 
            end )
        end

        local ofmdviprltext = vgui.Create("DLabel", ofmpanel)
        ofmdviprltext:Dock(TOP)
        ofmdviprltext:DockMargin(2, 8, 2, 8)
        ofmdviprltext:SetText("左键1秒后重载，右键5秒后重载")
        ofmdviprltext:SetTextColor(whitetext)
        ofmdviprltext:SetFont("oftext")

        


    end
    
    
    
    
    
    
    
    
    
    
    
    local ofmdvip = vgui.Create("DButton", ofmdv)
    ofmdvip:SetText("重要功能")
    ofmdvip:Dock(TOP)
    ofmdvip:DockMargin(0, 0, 0, 0)
    ofmdvip.DoClick = function()
        ofm_clear()
        ofm_dvip()
    end
    --[[
    local ofmdvrl = vgui.Create("DButton", ofmdv)
    ofmdvrl:SetText("重载模组")
    ofmdvrl:Dock(TOP)
    ofmdvrl:DockMargin(0, 0, 0, 0)
    ofmdvrl.DoClick = function()
        timer.Simple( 1, function() 
            RunConsoleCommand( "reload" ) 
        end )
    end
    ]]--

    local ofmhp = ofleftbar:Add("帮助中心")
    ofmhp.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ofbarcolor)
    end

    local function ofm_help(text)
        ofmpanel:Clear()
        --ofmpanel1:Clear()
        --ofmpanel2:Clear()
    
        local ofmlabeldisplayhelp = vgui.Create("DLabel", ofmpanel)
        ofmlabeldisplayhelp:Dock(FILL)
        --ofmlabeldisplayhelp:SetTextColor(Color(0, 0, 0))
        ofmlabeldisplayhelp:SetText("")
        ofmlabeldisplayhelp.Paint = function(self, w, h)
            local tline = ""
            local x = 0
            local y = 0
            surface.SetFont("oftext")
            surface.SetTextColor(255,255,255)
    
            local newlined = string.Split(text, "\n")
    
            for _, line in pairs(newlined) do
                local words = string.Split(line, " ")
    
                for _, word in pairs(words) do
                    local tx = surface.GetTextSize(word)
    
                    if x + tx >= w then
                        surface.SetTextPos(0, y)
                        surface.DrawText(tline)
                        local _, ty = surface.GetTextSize(tline)
                        y = y + ty
                        tline = ""
                        x = 0
                    end
    
                    tline = tline .. word .. " "
    
                    x = x + surface.GetTextSize(word .. " ")
                end
    
                surface.SetTextPos(0, y)
                surface.DrawText(tline)
                local _, ty = surface.GetTextSize(tline)
                y = y + ty
                tline = ""
                x = 0
            end
        end
    end
    --[[
    local DColorButton = vgui.Create( "DColorButton", frame )
    DColorButton:SetPos( 1, 28 )
    DColorButton:SetSize( 100, 30 )
    DColorButton:Paint( 100, 30 )
    DColorButton:SetText( "DColorButton" )
    DColorButton:SetColor( Color( 0, 110, 160 ) )
    function DColorButton:DoClick() -- Callback inherited from DLabel, which is DColorButton's base
        print( "I am clicked! My color is ", self:GetColor() )
    end
    ]]--


    for i, k in pairs(helpentries) do
        local helpbutton = vgui.Create("DButton", ofmhp)
        helpbutton:SetText(i)
        helpbutton:Dock(TOP)
        helpbutton:DockMargin(0, 0, 0, 0)
        helpbutton.DoClick = function()
            ofm_help(k)
        end
    end

    local ofmst = ofleftbar:Add("各项设置")
    ofmst.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ofbarcolor)
    end
    
    local function ofm_cs()
        ofmpanel:Clear()
        --ofmpanel1:Clear()
        --ofmpanel2:Clear()
        local ofmcs = vgui.Create("DFrame", ofmpanel)
        ofmcs:Dock(FILL)
        ofmcs:SetTitle( "选择你想要的主题" )
        ofmcs:SetDraggable( false  )
        ofmcs:ShowCloseButton( false  )
        ofmcs:GetIsMenu( ofmpanel )
        ofmcs.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color( 255, 255, 255, 0) )
        end
        
        local ofmcs1 = vgui.Create("DLabel", ofmcs)
        ofmcs1:Dock(TOP)
        ofmcs1:DockMargin(2, 8, 2, 8)
        ofmcs1:SetText("更改选项卡颜色")
        ofmcs1:SetFont("oftext")
        ofmcs1:SetTextColor(importanttextcolor)
        
        
        
        local ofmcp = vgui.Create( "DColorPalette", ofmcs )
        ofmcp:SetSize(xxp, yyp)
        ofmcp:Dock(TOP)
        ofmcp:DockPadding(0, 4, 0, 0)
        ofmcp:SetButtonSize( xxp/16,yyp/16 )

        local ofmcb = vgui.Create( "DColorButton", ofmcs )
        ofmcb:SetSize( xxp-10, 52 )
        ofmcb:Dock(TOP)
        ofmcb:DockPadding(2, 8, 2, 8)
        ofmcb:SetText("")
        ofmcb:SetColor( Color(0,0,0,255))
        --ofmcb:SetColor( Color(0, 0, 0, 156) )

        --function ofmcb :DoClick()
        --    ofbarcolor = value
        --end

        function ofmcb :DoRightClick()
            ofbarcolor = Color(0, 0, 0, 156)
        end

        local ofmctext = vgui.Create("DLabel", ofmcb)
        ofmctext:Dock(FILL)
        ofmctext:DockMargin(120*xxs, 4, 120*yys, 0)
        ofmctext:SetText("左键应用主题，右键还原默认")
        ofmctext:SetTextColor(whitetext)
        ofmctext:SetFont("oftextlarge")
        
        
        ofmcp.OnValueChanged = function( s, value )
            ofmcb:SetColor( value )
            function ofmcb :DoClick()
                ofbarcolor = value
            end
        end

        local ofmcs2 = vgui.Create("DLabel", ofmcs)
        ofmcs2:Dock(TOP)
        ofmcs2:DockMargin(2, 8, 2, 8)
        ofmcs2:SetText("更改强调色")
        ofmcs2:SetFont("oftext")
        ofmcs2:SetTextColor(importanttextcolor)
        
        
        
        local ofmcp2 = vgui.Create( "DColorPalette", ofmcs )
        ofmcp2:SetSize(xxp, yyp)
        ofmcp2:Dock(TOP)
        ofmcp2:DockPadding(0, 4, 0, 0)
        ofmcp2:SetButtonSize( xxp/16,yyp/16 )

        local ofmcb2 = vgui.Create( "DColorButton", ofmcs )
        ofmcb2:SetSize( xxp-10, 52 )
        ofmcb2:Dock(TOP)
        ofmcb2:DockPadding(2, 8, 2, 8)
        ofmcb2:SetText("")
        ofmcb2:SetColor( importanttextcolor )

        function ofmcb2 :DoRightClick()
            importanttextcolor = Color(255, 115, 0, 255)
            ofm_clear()
            ofm_cs()
        end

        local ofmctext2 = vgui.Create("DLabel", ofmcb2)
        ofmctext2:Dock(FILL)
        ofmctext2:DockMargin(120*xxs, 4, 120*yys, 0)
        ofmctext2:SetText("左键应用主题，右键还原默认")
        ofmctext2:SetTextColor(whitetext)
        ofmctext2:SetFont("oftextlarge")
        
        
        ofmcp2.OnValueChanged = function( s, value )
            ofmcb2:SetColor( value )
            function ofmcb2 :DoClick()
                importanttextcolor = value
                ofm_clear()
                ofm_cs()
            end
        end

        local ofmcs3 = vgui.Create("DLabel", ofmcs)
        ofmcs3:Dock(TOP)
        ofmcs3:DockMargin(2, 8, 2, 8)
        ofmcs3:SetText("这只是一个测试功能，目前颜色主题不能保存。")
        ofmcs3:SetFont("oftext")
        ofmcs3:SetTextColor(whitetext)



        
    end
    
    local ofmstcolorbutton = vgui.Create("DButton", ofmst)      --设置菜单
    ofmstcolorbutton:SetText("颜色主题")
    ofmstcolorbutton:Dock(TOP)
    ofmstcolorbutton:DockMargin(0, 0, 0, 0)
    ofmstcolorbutton.DoClick = function()
        ofm_clear()
        ofm_cs()
    end
    



    
end)



list.Set("DesktopWindows", "oftoolmenuc", {
    title = "晦弗工具箱",
    icon = "oftoollogo/oftoollogo.png",
    init = function(icon, window)
        RunConsoleCommand( "of_menu")
        
    end
})



