AddCSLuaFile()



local xx,yy=ScrW()/1920,ScrH()/1080     --玩家屏幕分辨率与我的屏幕分辨率的比
local xxp,yyp=800*xx-162,600*yy     --菜单大小
local xxs,yys=xxp/638,yyp/600   --倍率

surface.CreateFont("oftitle", {     --创建字体
    font = "Dream Han Sans CN",
    extended = true ,
    size = 40*xxs
})

surface.CreateFont("oftextlarge", {
    font = "Dream Han Sans CN W14",
    extended = true,
    size = 30*xxs
})

surface.CreateFont("oftext", {
    font = "Dream Han Sans CN W14",
    extended = true,
    size = 20*xxs
})


local i = GetConVar( "of_menu_customize_faded_black" )
local faded_black = Color(0, 0, 0, 180)
local x = GetConVar( "of_menu_customize_panel" )
local panel = Color(35, 35, 35, 67)

local oflistcolor = Color(200, 200, 200, 88)    --这玩意是左边列表框子的颜色
local ofbarcolor1 = Color(128, 0, 255, 190)    --这玩意是选项卡本来的颜色，点它会出现下拉菜单，我本来想把它们染成彩色的，但是这样太丑了
local ofbarcolor2 = Color(0, 157, 255, 190)
local ofbarcolor3 = Color(153, 212, 25, 190)
local ofbarcolor4 = Color(255, 0, 93, 190)
local ofbarcolor5 = Color(222, 215, 12, 190)
local ofbarcolorb1 = Color(255, 255, 255, 156)  --这个暂时没有用
local blacktext = Color(0, 0, 0, 207)  --黑色文字（目前没有用到）
local whitetext = Color(255, 255, 255, 255)  --白色文字

if file.Exists("oftk_ofbarcolor.txt", "DATA") then
    local json = file.Read("oftk_ofbarcolor.txt", "DATA") -- 从文件中读取JSON数据
    local data = util.JSONToTable(json) -- 将JSON数据转换为Lua表
    
    if data and data.color then
        ofbarcolor = data.color -- 获取颜色值
    else
        ofbarcolor = Color(72,72,72,255)
    end
else
    ofbarcolor = Color(72,72,72,255)
end

if file.Exists("oftk_importanttextcolor.txt", "DATA") then
    local json = file.Read("oftk_importanttextcolor.txt", "DATA") -- 从文件中读取JSON数据
    local data = util.JSONToTable(json) -- 将JSON数据转换为Lua表
    
    if data and data.color then
        importanttextcolor = data.color -- 获取颜色值
    else
        importanttextcolor = Color(255, 115, 0, 255)
    end
else
    importanttextcolor = Color(255, 115, 0, 255)
end

--                                                                        我发现这玩意不会自动换行，超出边界会显示不出来
--                                                                        ！这里是文字的边界
--下面的这堆代码我套用了别人的代码模板，我看不懂，但我大受震撼，这一部分文字会被后面的一堆代码读取并显示到菜单上
local helpentries = {
    ["基本功能"] = [[
    
    本工具箱支持大多数常用功能，现在你可以仅在一个地方管理和控制游戏和画面
    普通Gmod玩家，玩战役图的博主，动画制作者，插件作者，
    都能快速在其中找到自己想要的功能
    
    本工具箱的制作主旨是把大多数常用的重要功能集中在一起，
    给玩家提供一个方便快捷的管理界面。

    工具箱提供两种使用方式，如果你觉得使用DMenu太麻烦的话可以打开窗口
    （就是你现在眼前的窗口，可以通过C键菜单或Dmenu唤出）
    个人觉得用窗口比较方便，不过窗口目前还没完全开发好。以后还会有新功能加入
    而且这两个方法的功能是不统一的

    工具箱会支持一些基本插件，其中包括我常用的插件和某些热门插件
    当然。如果你不喜欢这些插件你也可以不订阅，这不是必须的！！

    我想做这样的快捷工具箱已经很久了，目前我还在不断完善它的代码。

    
    ]],
    ["关于插件"] = [[
    
    本插件的灵感来自与戈登走过去的工具箱。
    部分字体使用了可商用字体：梦源黑体，此字体可以自由传播、分享或嵌入。
    (不过目前字体导入后只有英文能显示为这个字体，具体情况还在研究)

    “重载模组”按钮点击后有一秒钟的延迟，
    这允许你在一秒内点击win键可以切出游戏，让游戏在后台载入。
    （这是人性化的设置，因为你可以切出去看B站，不用死盯着进度条了，
    Gmod载入时会有一段时间不能切出去）
    带有星号（*）的选项需要订阅第三方插件，这些插件不是必须订阅的。

    本工具箱的代码目前并不完善，我只能保证在单人模式中不会出问题。
    多人模式中部分功能必须开启作弊才能使用
    更多功能正在制作中。。。


    还有，记得去玩玩我做的地图！
    GMOD和CSGO都有噢！
    ]]
}

function createcheckbox(panel,text,convar)
    local checkbox = panel:Add( "DCheckBoxLabel" )
    checkbox:Dock(TOP)
    checkbox:DockMargin(2, 4, 2, 4)						
    checkbox:SetText(text)
    checkbox:SetTextColor(whitetext)
    checkbox:SetFont("oftext")			
    checkbox:SetConVar(convar)										
    checkbox:SizeToContents()
end

//if of_menu then of_menu:Remove() end    --菜单主体
//of_menu=nil 
local function of_menu_open( )
    //if of_menu then of_menu:Remove()end
    of_menu = vgui.Create("DFrame")
    of_menu:SetSize(800*xx, 600*yy)
    of_menu:Center()
    of_menu:SetTitle("晦涩弗里曼的工具箱V2.2.3")
    -- of_menu:SetSkin("ofminigamestheme")
    of_menu:SetDraggable(true)
    of_menu:MakePopup()
    of_menu:SetSizable(false)
    of_menu:SetKeyboardInputEnabled( false )
    surface.PlaySound("of_ui/ui_click_confirm1.wav")
    function of_menu :OnClose()
        surface.PlaySound("of_ui/ui_click_confirm2.wav")
    end
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

    local ofmpanel = vgui.Create("DPanel", of_menu)     --我试过用DScrollPanel，有些东西会被挡住
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
    ofmwellcomeud:AppendText("2024.3.10 \n小型更新，修复了装备部分自定义武器时prop实体无法按使用键拾起的问题。从代码中完全删除了of_god这个指令，改用官方的sbox_godmode，你必须拥有管理员权限才能修改这个变量，无敌状态改变时会有文字提示（包括复活时三秒无敌时间），如果你不喜欢可以使用工具箱的隐藏UI功能把它隐藏起来。\n")
    ofmwellcomeud:AppendText("2024.2.5 \n中型更新，增加了全局状态，修复了颜色主题。现在你设置的主题可以保存了！\n")
    ofmwellcomeud:AppendText("2024.1.22 \n紧急修复，近日，我的工具箱由于官方更新，导致了很多问题。具体表现为1，VJ Base的清除功能被破坏。2，地图中自带或自己摆的可破坏物件被击碎后会在原地留下虚影。3，某些实体或面板没法被正常清除。（卧槽排查了半天原来是自家模组出了问题，还以为是我代码写错了，一上午的代码都白写了）4，游戏重载后会直接崩溃。目前这些问题已经修复，调查结果为官方January 2024 Patch 2更新诱发了远古遗留的错误代码。如果本次紧急更新后仍有问题存在，请让我知道。\n")
    ofmwellcomeud:AppendText("2023.9.22 \n小型更新，增加了修改服务器游戏设置的功能\n（你可以直接在游戏里调整服务器的设置，不用担心开始游戏的时候勾选错了），\n模组支持新增无限子弹一键开关！\n此外，开发者可以使用的工具也增加了，可以一键显示材质开销，列出界面UI元素\n部分界面经过调整，使用舒适度增加\n")
    ofmwellcomeud:AppendText("2023.9.12 \n我的《异形丛生》地图发布了！用俯视射击游戏打CSGO地图是什么样的呢？\n进创意工坊搜：[Deathmatch]Lake from csgo\n")
    ofmwellcomeud:AppendText("2023.7.10 \n中型更新，增加了覆写玩家血量,自动回血，杀敌回血的功能\n并且现在没有挂载的模组会提示未挂载\n（这个功能可能会引起未知bug，如果在游戏里发现相关问题，请及时汇报）\n此外，新地图光华高中周年纪念版现已推出！请前往创意工坊下载！\n")
    ofmwellcomeud:AppendText("2023.6.19 \n修复了菜单卡移动的问题，（现在你可以自由移动了）增加背景NPC模组支持\n调整了菜单右侧的颜色以适应其他个性化主题，调整部分文字使其更易于理解\n修复隐藏多余UI覆盖原版隐藏hud功能的Bug以及无法单独隐藏地图细节的Bug\n添加TFA和TacRP武器替换的选项（这个东西我弄了好久），增加问题反馈界面\n")
    ofmwellcomeud:AppendText("2023.6.10 \n小型更新发布，支持NPC自动生成器，部分代码已改进\n")
    ofmwellcomeud:AppendText("2023.6.5 \n小型更新发布，支持SAII\n")
    ofmwellcomeud:AppendText("2023.5.28 \n中型更新发布，完善了帮助界面，易用性提升，增加了不少新功能（包括对一些常用模组的支持）\n增加界面UI音效,优化使用体验\n另外目前新地图的制作由于技术限制和个人准备考试暂停\n")
    ofmwellcomeud:AppendText("2023.4.3 \n加入了在车内开火和死后原地爆炸的选项，调整部分选项\n")
    ofmwellcomeud:AppendText("2023.4.1 \n工具箱已发布\n")
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
        surface.PlaySound("of_ui/ui_click_short1.wav")
        --surface.PlaySound("of_ui/ui_click_short" .. math.random(1, 2) .. ".wav")
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
	    ofmwarmvcbgod:SetText("无敌（需要管理员权限）")
        ofmwarmvcbgod:SetTextColor(whitetext)
        ofmwarmvcbgod:SetFont("oftext")				
	    ofmwarmvcbgod:SetConVar("sbox_godmode")										
	    ofmwarmvcbgod:SizeToContents()
        
        if ConVarExists("sv_infinite_ammo") then
            local ofmwarmvcbinfiniteammo = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmwarmvcbinfiniteammo:Dock(TOP)
            ofmwarmvcbinfiniteammo:DockMargin(2, 4, 2, 4)					
            ofmwarmvcbinfiniteammo:SetText("无限弹药*")
            ofmwarmvcbinfiniteammo:SetTextColor(whitetext)
            ofmwarmvcbinfiniteammo:SetFont("oftext")				
            ofmwarmvcbinfiniteammo:SetConVar("sv_infinite_ammo")										
            ofmwarmvcbinfiniteammo:SizeToContents()
        else
            local ofmwarmvcbinfiniteammo = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbinfiniteammo:Dock(TOP)
            ofmwarmvcbinfiniteammo:DockMargin(2, 4, 2, 4)
            ofmwarmvcbinfiniteammo:SetText("（未挂载）无限弹药*")
            ofmwarmvcbinfiniteammo:SetFont("oftext")
            ofmwarmvcbinfiniteammo:SetTextColor(whitetext) 
        end

        local ofmwarmvcballowweaponsinvehicle = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarmvcballowweaponsinvehicle:Dock(TOP)
        ofmwarmvcballowweaponsinvehicle:DockMargin(2, 4, 2, 4)					
	    ofmwarmvcballowweaponsinvehicle:SetText("允许在车内使用武器")
        ofmwarmvcballowweaponsinvehicle:SetTextColor(whitetext)
        ofmwarmvcballowweaponsinvehicle:SetFont("oftext")				
	    ofmwarmvcballowweaponsinvehicle:SetConVar("of_allowweaponsinvehicle")										
	    ofmwarmvcballowweaponsinvehicle:SizeToContents()

        local ConflictExistshealthforkills = file.Exists("lua/autorun/healthforkills.lua","GAME")
        local ConflictExistshealthregen = file.Exists("lua/autorun/healthregen.lua","GAME")

        if ConflictExistshealthforkills == false and ConflictExistshealthregen == false then

            local ofmwarmvcboverridehealth = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmwarmvcboverridehealth:Dock(TOP)
            ofmwarmvcboverridehealth:DockMargin(2, 2, 2, 0)						
            ofmwarmvcboverridehealth:SetText("覆写玩家生命值")
            ofmwarmvcboverridehealth:SetTextColor(whitetext)	
            ofmwarmvcboverridehealth:SetFont("oftext")			
            ofmwarmvcboverridehealth:SetConVar("of_overridehealth")										
            ofmwarmvcboverridehealth:SizeToContents()

            local ofmwarmvcboverridehealthvalue = vgui.Create( "DNumSlider", ofmpanel1 )
            ofmwarmvcboverridehealthvalue:Dock(TOP)
            ofmwarmvcboverridehealthvalue:DockMargin(2, 2, 2, 2)
            ofmwarmvcboverridehealthvalue:SetText("自定义生命值" )
            ofmwarmvcboverridehealthvalue:SetMin( 1 )
            ofmwarmvcboverridehealthvalue:SetMax( 1000 )
            ofmwarmvcboverridehealthvalue:SetDecimals( 0 )
            ofmwarmvcboverridehealthvalue:SetConVar( "of_overridehealthvalue" )

            local ofmwarmvcbhealthregen = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmwarmvcbhealthregen:Dock(TOP)
            ofmwarmvcbhealthregen:DockMargin(2, 2, 2, 0)						
            ofmwarmvcbhealthregen:SetText("玩家自动回血")
            ofmwarmvcbhealthregen:SetTextColor(whitetext)	
            ofmwarmvcbhealthregen:SetFont("oftext")			
            ofmwarmvcbhealthregen:SetConVar("of_healthregen")										
            ofmwarmvcbhealthregen:SizeToContents()

            local ofmwarmvcbhealthregenspeed = vgui.Create( "DNumSlider", ofmpanel1 )
            ofmwarmvcbhealthregenspeed:Dock(TOP)
            ofmwarmvcbhealthregenspeed:DockMargin(2, 2, 2, 2)
            ofmwarmvcbhealthregenspeed:SetText( "回血速度" )
            ofmwarmvcbhealthregenspeed:SetMin( 1 )
            ofmwarmvcbhealthregenspeed:SetMax( 10 )
            ofmwarmvcbhealthregenspeed:SetDecimals( 0 )
            ofmwarmvcbhealthregenspeed:SetConVar( "of_healthregen_speed" )

            local ofmwarmvcbhealthforkills = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmwarmvcbhealthforkills:Dock(TOP)
            ofmwarmvcbhealthforkills:DockMargin(2, 2, 2, 0)						
            ofmwarmvcbhealthforkills:SetText("杀敌回血")
            ofmwarmvcbhealthforkills:SetTextColor(whitetext)	
            ofmwarmvcbhealthforkills:SetFont("oftext")			
            ofmwarmvcbhealthforkills:SetConVar("of_healthforkills")										
            ofmwarmvcbhealthforkills:SizeToContents()

            local ofmwarmvcbhealthforkillsvalue = vgui.Create( "DNumSlider", ofmpanel1 )
            ofmwarmvcbhealthforkillsvalue:Dock(TOP)
            ofmwarmvcbhealthforkillsvalue:DockMargin(2, 2, 2, 2)
            ofmwarmvcbhealthforkillsvalue:SetText( "回血量" )
            ofmwarmvcbhealthforkillsvalue:SetMin( 10 )
            ofmwarmvcbhealthforkillsvalue:SetMax( 50 )
            ofmwarmvcbhealthforkillsvalue:SetDecimals( 0 )
            ofmwarmvcbhealthforkillsvalue:SetConVar( "of_healthforkills_value" )
        else
            local ofmwarmvcbconflictexistshealth1 = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbconflictexistshealth1:Dock(TOP)
            ofmwarmvcbconflictexistshealth1:DockMargin(2, 8, 2, 4)
            ofmwarmvcbconflictexistshealth1:SetText("你订阅了Healthrewards或Health Regeneration")
            ofmwarmvcbconflictexistshealth1:SetFont("oftext")
            ofmwarmvcbconflictexistshealth1:SetTextColor(whitetext)

            local ofmwarmvcbconflictexistshealth2 = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbconflictexistshealth2:Dock(TOP)
            ofmwarmvcbconflictexistshealth2:DockMargin(2, 8, 2, 4)
            ofmwarmvcbconflictexistshealth2:SetText("会引起冲突，因此自定义血量功能被禁用了")
            ofmwarmvcbconflictexistshealth2:SetFont("oftext")
            ofmwarmvcbconflictexistshealth2:SetTextColor(whitetext)

        end
        

        local ofmwarmv1_1 = vgui.Create("DLabel", ofmpanel1)
        ofmwarmv1_1:Dock(TOP)
        ofmwarmv1_1:DockMargin(2, 8, 2, 8)
        ofmwarmv1_1:SetText("移动方式")
        ofmwarmv1_1:SetFont("oftext")
        ofmwarmv1_1:SetTextColor(importanttextcolor)

        if ConVarExists("vwarzone_enableskydive") then
            local ofmwarmvcbskydive = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmwarmvcbskydive:Dock(TOP)
            ofmwarmvcbskydive:DockMargin(2, 4, 2, 4)						
            ofmwarmvcbskydive:SetText("战区空中滑行*")
            ofmwarmvcbskydive:SetTextColor(whitetext)
            ofmwarmvcbskydive:SetFont("oftext")				
            ofmwarmvcbskydive:SetConVar("vwarzone_enableskydive")										
            ofmwarmvcbskydive:SizeToContents()
        else
            local ofmwarmvcbskydive = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbskydive:Dock(TOP)
            ofmwarmvcbskydive:DockMargin(2, 4, 2, 4)
            ofmwarmvcbskydive:SetText("（未挂载）战区空中滑行*")
            ofmwarmvcbskydive:SetFont("oftext")
            ofmwarmvcbskydive:SetTextColor(whitetext) 
        end

        if ConVarExists("vwarzone_enableparachute") then
            local ofmwarmvcbparachute = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmwarmvcbparachute:Dock(TOP)
            ofmwarmvcbparachute:DockMargin(2, 4, 2, 4)						
            ofmwarmvcbparachute:SetText("战区降落伞*")
            ofmwarmvcbparachute:SetTextColor(whitetext)	
            ofmwarmvcbparachute:SetFont("oftext")			
            ofmwarmvcbparachute:SetConVar("vwarzone_enableparachute")										
            ofmwarmvcbparachute:SizeToContents()
        else
            local ofmwarmvcbparachute = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbparachute:Dock(TOP)
            ofmwarmvcbparachute:DockMargin(2, 4, 2, 4)
            ofmwarmvcbparachute:SetText("（未挂载）战区降落伞*")
            ofmwarmvcbparachute:SetFont("oftext")
            ofmwarmvcbparachute:SetTextColor(whitetext) 
        end




        local ofmwarmv1_2 = vgui.Create("DLabel", ofmpanel1)
        ofmwarmv1_2:Dock(TOP)
        ofmwarmv1_2:DockMargin(2, 8, 2, 8)
        ofmwarmv1_2:SetText("快捷菜单")
        ofmwarmv1_2:SetFont("oftext")
        ofmwarmv1_2:SetTextColor(importanttextcolor)


        local AddonExistarcradialcustomize = file.Exists("lua/autorun/cl_arctic_radial_menu.lua","GAME")

        if AddonExistarcradialcustomize == true then
            local ofmwarmvcbarc = vgui.Create("DButton", ofmpanel1)
            ofmwarmvcbarc:SetText("ARC放射菜单设置*")
            ofmwarmvcbarc:Dock(TOP)
            ofmwarmvcbarc:DockMargin(2, 4, 2, 4)
            ofmwarmvcbarc.DoClick = function()
                RunConsoleCommand( "arc_radial_customize")
            end
        else
            local ofmwarmvcbarc = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbarc:Dock(TOP)
            ofmwarmvcbarc:DockMargin(2, 4, 2, 4)
            ofmwarmvcbarc:SetText("（未安装）ARC放射菜单设置*")
            ofmwarmvcbarc:SetFont("oftext")
            ofmwarmvcbarc:SetTextColor(whitetext) 
        end

        if concommand.GetTable()["weapon_properties_editor"] then
            local ofmwarmvcbwped = vgui.Create("DButton", ofmpanel1)
            ofmwarmvcbwped:SetText("武器编辑替换工具*")
            ofmwarmvcbwped:Dock(TOP)
            ofmwarmvcbwped:DockMargin(2, 4, 2, 4)
            ofmwarmvcbwped.DoClick = function()
                RunConsoleCommand( "weapon_properties_editor")
            end
        else
            local ofmwarmvcbwped = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbwped:Dock(TOP)
            ofmwarmvcbwped:DockMargin(2, 4, 2, 4)
            ofmwarmvcbwped:SetText("（未挂载）武器编辑替换工具*")
            ofmwarmvcbwped:SetFont("oftext")
            ofmwarmvcbwped:SetTextColor(whitetext) 
        end

        if concommand.GetTable()["npc_model_randomizer_gui"] then
            local ofmwarmvcbnmrg = vgui.Create("DButton", ofmpanel1)
            ofmwarmvcbnmrg:SetText("NPC模型随机化设置*")
            ofmwarmvcbnmrg:Dock(TOP)
            ofmwarmvcbnmrg:DockMargin(2, 4, 2, 4)
            ofmwarmvcbnmrg.DoClick = function()
                RunConsoleCommand( "npc_model_randomizer_gui")
            end
        else
            local ofmwarmvcbnmrg = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbnmrg:Dock(TOP)
            ofmwarmvcbnmrg:DockMargin(2, 4, 2, 4)
            ofmwarmvcbnmrg:SetText("（未挂载）NPC模型随机化设置*")
            ofmwarmvcbnmrg:SetFont("oftext")
            ofmwarmvcbnmrg:SetTextColor(whitetext) 
        end

        if concommand.GetTable()["zippy_map_spawner_group_menu"] then
            local ofmwarmvcbzmsgm = vgui.Create("DButton", ofmpanel1)
            ofmwarmvcbzmsgm:SetText("NPC自动生成器设置*")
            ofmwarmvcbzmsgm:Dock(TOP)
            ofmwarmvcbzmsgm:DockMargin(2, 4, 2, 4)
            ofmwarmvcbzmsgm.DoClick = function()
                RunConsoleCommand( "zippy_map_spawner_group_menu")
            end
        else
            local ofmwarmvcbzmsgm = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbzmsgm:Dock(TOP)
            ofmwarmvcbzmsgm:DockMargin(2, 4, 2, 4)
            ofmwarmvcbzmsgm:SetText("（未挂载）NPC自动生成器设置*")
            ofmwarmvcbzmsgm:SetFont("oftext")
            ofmwarmvcbzmsgm:SetTextColor(whitetext) 
        end




        

        -- local ofmwarmv1_3 = vgui.Create("DLabel", ofmpanel1)
        -- ofmwarmv1_3:Dock(TOP)
        -- ofmwarmv1_3:DockMargin(2, 8, 2, 8)
        -- ofmwarmv1_3:SetText("设置调控")
        -- ofmwarmv1_3:SetFont("oftext")
        -- ofmwarmv1_3:SetTextColor(importanttextcolor)

        -- local ofmwarmvcbsboxmp = vgui.Create( "DNumSlider", ofmpanel1 )
        -- ofmwarmvcbsboxmp:Dock(TOP)
        -- ofmwarmvcbsboxmp:DockMargin(2, 4, 2, 4)
        -- ofmwarmvcbsboxmp:SetText( "地图道具限制" )
        -- ofmwarmvcbsboxmp:SetMin( 0 )
        -- ofmwarmvcbsboxmp:SetMax( 256 )
        -- ofmwarmvcbsboxmp:SetDecimals( 0 )
        -- ofmwarmvcbsboxmp:SetConVar( "sbox_maxprops" )

        -- local ofmwarmvcbsboxmnpc = vgui.Create( "DNumSlider", ofmpanel1 )
        -- ofmwarmvcbsboxmnpc:Dock(TOP)
        -- ofmwarmvcbsboxmnpc:DockMargin(2, 4, 2, 4)
        -- ofmwarmvcbsboxmnpc:SetText( "地图NPC限制" )
        -- ofmwarmvcbsboxmnpc:SetMin( 0 )
        -- ofmwarmvcbsboxmnpc:SetMax( 256 )
        -- ofmwarmvcbsboxmnpc:SetDecimals( 0 )
        -- ofmwarmvcbsboxmnpc:SetConVar( "sbox_maxnpcs" )

        -- local ofmwarmvcbsboxmrg = vgui.Create( "DNumSlider", ofmpanel1 )
        -- ofmwarmvcbsboxmrg:Dock(TOP)
        -- ofmwarmvcbsboxmrg:DockMargin(2, 4, 2, 4)
        -- ofmwarmvcbsboxmrg:SetText( "地图布娃娃限制" )
        -- ofmwarmvcbsboxmrg:SetMin( 0 )
        -- ofmwarmvcbsboxmrg:SetMax( 256 )
        -- ofmwarmvcbsboxmrg:SetDecimals( 0 )
        -- ofmwarmvcbsboxmrg:SetConVar( "sbox_maxragdolls" )



        

        local ofmwarmv2 = vgui.Create("DLabel", ofmpanel2)
        ofmwarmv2:Dock(TOP)
        ofmwarmv2:DockMargin(2, 8, 2, 8)
        ofmwarmv2:SetText("敌人设置")
        ofmwarmv2:SetFont("oftext")
        ofmwarmv2:SetTextColor(importanttextcolor)

        if ConVarExists("kn_realistic_combine") then
            local ofmwarmvcbrc = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbrc:Dock(TOP)
            ofmwarmvcbrc:DockMargin(2, 4, 2, 4)						
            ofmwarmvcbrc:SetText("F.E.A.R AI*")
            ofmwarmvcbrc:SetTextColor(whitetext)
            ofmwarmvcbrc:SetFont("oftext")				
            ofmwarmvcbrc:SetConVar("kn_realistic_combine")										
            ofmwarmvcbrc:SizeToContents()
        else
            local ofmwarmvcbrc = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbrc:Dock(TOP)
            ofmwarmvcbrc:DockMargin(2, 4, 2, 4)
            ofmwarmvcbrc:SetText("（未挂载）F.E.A.R AI*")
            ofmwarmvcbrc:SetFont("oftext")
            ofmwarmvcbrc:SetTextColor(whitetext) 
        end

        if ConVarExists("saii_enabled") then
            local ofmwarmvcbse = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbse:Dock(TOP)
            ofmwarmvcbse:DockMargin(2, 4, 2, 4)						
            ofmwarmvcbse:SetText("Sninctbur的AI改进*")
            ofmwarmvcbse:SetTextColor(whitetext)
            ofmwarmvcbse:SetFont("oftext")				
            ofmwarmvcbse:SetConVar("saii_enabled")										
            ofmwarmvcbse:SizeToContents()
        else
            local ofmwarmvcbse = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbse:Dock(TOP)
            ofmwarmvcbse:DockMargin(2, 4, 2, 4)
            ofmwarmvcbse:SetText("（未挂载）Sninctbur的AI改进*")
            ofmwarmvcbse:SetFont("oftext")
            ofmwarmvcbse:SetTextColor(whitetext) 
        end

        if ConVarExists("z_npc_nav_enabled") then
            local ofmwarmvcbnn = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbnn:Dock(TOP)
            ofmwarmvcbnn:DockMargin(2, 4, 2, 4)					
            ofmwarmvcbnn:SetText("NPC用导航网格作为路点寻路*")
            ofmwarmvcbnn:SetTextColor(whitetext)
            ofmwarmvcbnn:SetFont("oftext")				
            ofmwarmvcbnn:SetConVar("z_npc_nav_enabled")										
            ofmwarmvcbnn:SizeToContents()
        else
            local ofmwarmvcbnn = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbnn:Dock(TOP)
            ofmwarmvcbnn:DockMargin(2, 4, 2, 4)
            ofmwarmvcbnn:SetText("（未挂载）NPC用导航网格寻路*")
            ofmwarmvcbnn:SetFont("oftext")
            ofmwarmvcbnn:SetTextColor(whitetext) 
        end

        
        if ConVarExists("bgn_enable") then
            local ofmwarmvcbbgn = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbbgn:Dock(TOP)
            ofmwarmvcbbgn:DockMargin(2, 4, 2, 4)					
            ofmwarmvcbbgn:SetText("背景NPC（需要导航网格）*")
            ofmwarmvcbbgn:SetTextColor(whitetext)
            ofmwarmvcbbgn:SetFont("oftext")				
            ofmwarmvcbbgn:SetConVar("bgn_enable")										
            ofmwarmvcbbgn:SizeToContents()
        else
            local ofmwarmvcbbgn = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbbgn:Dock(TOP)
            ofmwarmvcbbgn:DockMargin(2, 4, 2, 4)
            ofmwarmvcbbgn:SetText("（未挂载）背景NPC（需要导航网格）*")
            ofmwarmvcbbgn:SetFont("oftext")
            ofmwarmvcbbgn:SetTextColor(whitetext) 
        end

        if ConVarExists("arc9_replace_spawned") then
            local ofmwarmvcbarc9rs = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbarc9rs:Dock(TOP)
            ofmwarmvcbarc9rs:DockMargin(2, 4, 2, 4)					
            ofmwarmvcbarc9rs:SetText("地面武器替换为ARC9武器*")
            ofmwarmvcbarc9rs:SetTextColor(whitetext)
            ofmwarmvcbarc9rs:SetFont("oftext")				
            ofmwarmvcbarc9rs:SetConVar("arc9_replace_spawned")										
            ofmwarmvcbarc9rs:SizeToContents()
        else
            local ofmwarmvcbarc9rs = vgui.Create("DLabel", ofmpanel1)
            ofmwarmvcbarc9rs:Dock(TOP)
            ofmwarmvcbarc9rs:DockMargin(2, 4, 2, 4)
            ofmwarmvcbarc9rs:SetText("（未挂载）地面武器替换为ARC9武器*")
            ofmwarmvcbarc9rs:SetFont("oftext")
            ofmwarmvcbarc9rs:SetTextColor(whitetext) 
        end

        if ConVarExists("arc9_npc_autoreplace") then
            local ofmwarmvcbarc9wp = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbarc9wp:Dock(TOP)
            ofmwarmvcbarc9wp:DockMargin(2, 4, 2, 4)					
            ofmwarmvcbarc9wp:SetText("NPC原版武器替换为同类ARC9武器*")
            ofmwarmvcbarc9wp:SetTextColor(whitetext)
            ofmwarmvcbarc9wp:SetFont("oftext")				
            ofmwarmvcbarc9wp:SetConVar("arc9_npc_autoreplace")										
            ofmwarmvcbarc9wp:SizeToContents()
        else
            local ofmwarmvcbarc9wp = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbarc9wp:Dock(TOP)
            ofmwarmvcbarc9wp:DockMargin(2, 4, 2, 4)
            ofmwarmvcbarc9wp:SetText("（未挂载）NPC分发ARC9武器*")
            ofmwarmvcbarc9wp:SetFont("oftext")
            ofmwarmvcbarc9wp:SetTextColor(whitetext) 
        end

        if ConVarExists("arccw_npc_replace") then
            local ofmwarmvcbarccwwp = ofmpanel2:Add( "DCheckBoxLabel" )
            ofmwarmvcbarccwwp:Dock(TOP)
            ofmwarmvcbarccwwp:DockMargin(2, 4, 2, 4)					
            ofmwarmvcbarccwwp:SetText("NPC原版武器替换为同类ARCCW武器*")
            ofmwarmvcbarccwwp:SetTextColor(whitetext)
            ofmwarmvcbarccwwp:SetFont("oftext")				
            ofmwarmvcbarccwwp:SetConVar("arccw_npc_replace")										
            ofmwarmvcbarccwwp:SizeToContents()
        else
            local ofmwarmvcbarccwwp = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbarccwwp:Dock(TOP)
            ofmwarmvcbarccwwp:DockMargin(2, 4, 2, 4)
            ofmwarmvcbarccwwp:SetText("（未挂载）NPC分发ARCCW武器*")
            ofmwarmvcbarccwwp:SetFont("oftext")
            ofmwarmvcbarccwwp:SetTextColor(whitetext) 
        end        

        



        -- local ofmwarmvcbtfawp = ofmpanel2:Add( "DCheckBoxLabel" )
	    -- ofmwarmvcbtfawp:Dock(TOP)
        -- ofmwarmvcbtfawp:DockMargin(2, 4, 2, 4)					
	    -- ofmwarmvcbtfawp:SetText("NPC替换TFA武器*")
        -- ofmwarmvcbtfawp:SetTextColor(whitetext)
        -- ofmwarmvcbtfawp:SetFont("oftext")				
	    -- ofmwarmvcbtfawp:SetConVar("of_tfa_weapon")										
	    -- ofmwarmvcbtfawp:SizeToContents()
        -----------------------------------------------------------------------------------------------
        





        local tfanpcwpList = ofmpanel2:Add( "DListView" )
		tfanpcwpList:Dock(TOP)
		tfanpcwpList:DockMargin(8, 4, 8, 4)
        tfanpcwpList:SetHeight(100) 
        tfanpcwpList:AddColumn("TFA武器替换"):SetWidth(xxp/4)
        tfanpcwpList:AddColumn("真实名称"):SetWidth(xxp/4)
        tfanpcwpList:SetMultiSelect(false)
        local weaponCats = {}
        for _, wep in pairs(weapons.GetList()) do
            if wep and wep.Spawnable and weapons.IsBasedOn(wep.ClassName, "tfa_gun_base") then
                local cat = wep.Category or "Other"
                weaponCats[cat] = weaponCats[cat] or {}

                table.insert(weaponCats[cat], {
                    ["class"] = wep.ClassName,
                    ["title"] = wep.PrintName or wep.ClassName
                })
            end
        end

        local catKeys = table.GetKeys(weaponCats)
        table.sort(catKeys, function(a, b) return a < b end)

        -- for _, k in ipairs(catKeys) do
        --     local v = weaponCats[k]
        --     local tfanpcwpListLine = tfanpcwpList:AddLine(k)
        --     --local tfanpcwpListLine = tfanpcwpList:Add( "DMenu" )
        --     table.SortByMember(v, "title", true)
        --     tfanpcwpListLine:Dock( TOP )
	    --     tfanpcwpListLine:DockMargin(0, 0, 0, 0)     
            
        --     local tfanpcwpMenu = DermaMenu()

        --     for _, b in ipairs(v) do
        --         tfanpcwpMenu:AddCVar(b.title, "gmod_npcweapon", b.class)
        --     end
        --     function tfanpcwpListLine.DoClick(parent, lineID, line)
        --         tfanpcwpMenu:Open()
        --     end
               
        -- end

        

        --local LastCat = 1
        --local of_tfa_swep_box = vgui.Create("DComboBox", ofmpanel2)
        --of_tfa_swep_box:Dock(TOP)
        for _, k in ipairs(catKeys) do
            local v = weaponCats[k]
            --local tfanpcwpbox = of_tfa_swep_box:AddChoice(k)
            table.SortByMember(v, "title", true)
            for _, b in ipairs(v) do

                tfanpcwpList:AddLine(b.title,b.class)
        
            end
        end
        --of_tfa_swep_box:ChooseOptionID(weaponCats[LastCat] && LastCat or 1)
        --原来有一个用来选择武器包名称的box现在删掉了，因为我不会弄



        function tfanpcwpList.DoDoubleClick(parent, lineID, line)

            local firstColumnText = line:GetColumnText(1)
            local secondColumnText =  line:GetColumnText(2)
            RunConsoleCommand("gmod_npcweapon", secondColumnText)
    
        end

        local tacrpnpcwpList = ofmpanel2:Add( "DListView" )
		tacrpnpcwpList:Dock(TOP)
		tacrpnpcwpList:DockMargin(8, 4, 8, 4)
        tacrpnpcwpList:SetHeight(100) 
        tacrpnpcwpList:AddColumn("TacRP武器替换"):SetWidth(xxp/4)
        tacrpnpcwpList:AddColumn("真实名称"):SetWidth(xxp/4)
        tacrpnpcwpList:SetMultiSelect(false)
        local weaponCatsTacRP = {}
        for _, wep in pairs(weapons.GetList()) do
            if wep and wep.Spawnable and weapons.IsBasedOn(wep.ClassName, "tacrp_base") then
                local cat = wep.Category or "Other"
                weaponCatsTacRP[cat] = weaponCatsTacRP[cat] or {}

                table.insert(weaponCatsTacRP[cat], {
                    ["class"] = wep.ClassName,
                    ["title"] = wep.PrintName or wep.ClassName
                })
            end
        end

        local catKeystacrp = table.GetKeys(weaponCatsTacRP)
        table.sort(catKeystacrp, function(a, b) return a < b end)

        for _, k in ipairs(catKeystacrp) do
            local v = weaponCatsTacRP[k]
            table.SortByMember(v, "title", true)
            for _, b in ipairs(v) do

                tacrpnpcwpList:AddLine(b.title,b.class)
        
            end
        end

        function tacrpnpcwpList.DoDoubleClick(parent, lineID, line)

            local firstColumnText = line:GetColumnText(1)
            local secondColumnText =  line:GetColumnText(2)
            RunConsoleCommand("gmod_npcweapon", secondColumnText)
    
        end



        
        local ofmwarmvcbtfar = vgui.Create("DButton", ofmpanel2)
        ofmwarmvcbtfar:SetText("重置回默认武器")
        ofmwarmvcbtfar:Dock(TOP)
        ofmwarmvcbtfar:DockMargin(2, 4, 2, 4)
        ofmwarmvcbtfar.DoClick = function()
            RunConsoleCommand("gmod_npcweapon", "")
        end
        
        

        -- 以下的注释是一种更高级的派生方法，但是我没用它们，因为我也不知道怎么搞

        -- local LastCat = 1
        -- local tfanpcwpList = list.Get(_list)
        -- local items = {}
        -- local of_tfa_swep_box = vgui.Create("DComboBox", ofmpanel2)
        -- of_tfa_swep_box:Dock(TOP)
        -- -- Add all categories from the list:
        -- -- local cats = {}
        -- -- local function cat_used(cat)
        -- --     for _,v in ipairs(cats) do
        -- --         if (v == cat) then return true end
        -- --     end
        -- -- end
        -- -- for _, wep in pairs(weapons.GetList()) do
        -- --     local cat = item.Category
        -- --     if !cat_used(cat) then
        -- --         of_tfa_swep_box:AddChoice(cat)
        -- --         table.insert(cats, cat)
        -- --     end
        -- -- end
        -- -- of_tfa_swep_box:ChooseOptionID(cats[LastCat] && LastCat or 1)


        -- local weaponCats = {}
        -- for _, wep in pairs(weapons.GetList()) do
        --     if wep and wep.Spawnable and weapons.IsBasedOn(wep.ClassName, "tfa_gun_base") then
        --         local cat = wep.Category or "Other"
        --         weaponCats[cat] = weaponCats[cat] or {}

        --         table.insert(weaponCats[cat], {
        --             ["class"] = wep.ClassName,
        --             ["title"] = wep.PrintName or wep.ClassName
        --         })
        --     end
        -- end

        -- local catKeys = table.GetKeys(weaponCats)
        -- table.sort(catKeys, function(a, b) return a < b end)

        -- for _, k in ipairs(catKeys) do
        --     local v = weaponCats[k]
        --     local tfanpcwpbox = of_tfa_swep_box:AddChoice(k)
        --     table.SortByMember(v, "title", true)
        -- end

        -- of_tfa_swep_box:ChooseOptionID(weaponCats[LastCat] && LastCat or 1)


        -- local function update_tfanpcwpList()
        --     -- Clear item data list:
        --     items = {}
        --     -- Remove old lines:
        --     for k in ipairs(tfanpcwpList:GetLines()) do
        --         tfanpcwpList:RemoveLine(k)
        --     end
        --     -- Make new ones and populate item data list:
        --     for k,data in pairs(tfanpcwpList) do
        --         if data.Category == tfanpcwpList:GetSelected() then
        --             tfanpcwpList:AddSubMenu(data.Name or k)
        --             table.insert(items, data)
        --         end
        --     end
    
        --     tfanpcwpList:SortByColumn(1)
        -- end
        -- -- Update directly when opening the panel:
        -- update_tfanpcwpList()

        -- local npcWepList = list.GetForEdit("NPCUsableWeapons")

        -- hook.Add("PlayerSpawnNPC", "TFACheckNPCWeapon", function(plyv, npcclassv, wepclassv)
        --     if type(wepclassv) ~= "string" or wepclassv == "" then return end

        --     if not npcWepList[wepclassv] then -- do not copy the table
        --         local wep = weapons.GetStored(wepclassv)

        --         if wep and (wep.Spawnable and not wep.AdminOnly) and weapons.IsBasedOn(wep.ClassName, "tfa_gun_base") then
        --             npcWepList[wepclassv] = {
        --                 ["class"] = wep.ClassName,
        --                 ["title"] = wep.PrintName or wep.ClassName
        --             }
        --         end
        --     end
        -- end)

        -----------------------------------------------------------------------------------------------

        

        local AddonExistnpcmodelrandomizer = file.Exists("lua/autorun/froze_combine_s_model_randomizer.lua","GAME")

        if AddonExistnpcmodelrandomizer == true then
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
        else
            local ofmwarmvcbrsr = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbrsr:Dock(TOP)
            ofmwarmvcbrsr:DockMargin(2, 4, 2, 4)
            ofmwarmvcbrsr:SetText("（未安装）NPC随机皮肤*")
            ofmwarmvcbrsr:SetFont("oftext")
            ofmwarmvcbrsr:SetTextColor(whitetext) 

            local ofmwarmvcbrbr = vgui.Create("DLabel", ofmpanel2)
            ofmwarmvcbrbr:Dock(TOP)
            ofmwarmvcbrbr:DockMargin(2, 4, 2, 4)
            ofmwarmvcbrbr:SetText("（未安装）NPC随机身体组件*")
            ofmwarmvcbrbr:SetFont("oftext")
            ofmwarmvcbrbr:SetTextColor(whitetext) 
        end
    end


    local ofmwarmv = vgui.Create("DButton", ofmwar)
    ofmwarmv:SetText("游戏体验")
    ofmwarmv:Dock(TOP)
    ofmwarmv:DockMargin(0, 0, 0, 0)
    ofmwarmv.DoClick = function()
        ofm_clear()
        ofm_warmv()
    end

    local function ofm_warserver()
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

        local ofmwarservert1 = vgui.Create("DLabel", ofmpanel1)
        ofmwarservert1:Dock(TOP)
        ofmwarservert1:DockMargin(2, 8, 2, 8)
        ofmwarservert1:SetText("单人模式")
        ofmwarservert1:SetFont("oftext")
        ofmwarservert1:SetTextColor(importanttextcolor)



        local ofmwarserversbox_weapons = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_weapons:Dock(TOP)
        ofmwarserversbox_weapons:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_weapons:SetText("出生点武器配给")
        ofmwarserversbox_weapons:SetTextColor(whitetext)
        ofmwarserversbox_weapons:SetFont("oftext")			
	    ofmwarserversbox_weapons:SetConVar("sbox_weapons")										
	    ofmwarserversbox_weapons:SizeToContents()

        local ofmwarserversbox_godmode = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_godmode:Dock(TOP)
        ofmwarserversbox_godmode:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_godmode:SetText("全玩家无敌模式")
        ofmwarserversbox_godmode:SetTextColor(whitetext)
        ofmwarserversbox_godmode:SetFont("oftext")			
	    ofmwarserversbox_godmode:SetConVar("sbox_godmode")										
	    ofmwarserversbox_godmode:SizeToContents()

        local ofmwarservergmod_suit = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarservergmod_suit:Dock(TOP)
        ofmwarservergmod_suit:DockMargin(2, 4, 2, 4)						
	    ofmwarservergmod_suit:SetText("启用防护服（体力限制）")
        ofmwarservergmod_suit:SetTextColor(whitetext)
        ofmwarservergmod_suit:SetFont("oftext")			
	    ofmwarservergmod_suit:SetConVar("gmod_suit")										
	    ofmwarservergmod_suit:SizeToContents()

        local ofmwarservermp_falldamage = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarservermp_falldamage:Dock(TOP)
        ofmwarservermp_falldamage:DockMargin(2, 4, 2, 4)						
	    ofmwarservermp_falldamage:SetText("启用真实的跌落伤害")
        ofmwarservermp_falldamage:SetTextColor(whitetext)
        ofmwarservermp_falldamage:SetFont("oftext")			
	    ofmwarservermp_falldamage:SetConVar("mp_falldamage")										
	    ofmwarservermp_falldamage:SizeToContents()

        local ofmwarservergravity = vgui.Create( "DNumSlider", ofmpanel1 )
        ofmwarservergravity:Dock(TOP)
        ofmwarservergravity:DockMargin(2, 2, 2, 2)
        ofmwarservergravity:SetText("服务器重力" )
        ofmwarservergravity:SetMin( 0 )
        ofmwarservergravity:SetMax( 1000 )
        ofmwarservergravity:SetDecimals( 0 )
        ofmwarservergravity:SetConVar( "sv_gravity" )

        local ofmwarservert2 = vgui.Create("DLabel", ofmpanel1)
        ofmwarservert2:Dock(TOP)
        ofmwarservert2:DockMargin(2, 8, 2, 8)
        ofmwarservert2:SetText("多人模式")
        ofmwarservert2:SetFont("oftext")
        ofmwarservert2:SetTextColor(importanttextcolor)

        local ofmwarserverphysgun_limited = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserverphysgun_limited:Dock(TOP)
        ofmwarserverphysgun_limited:DockMargin(2, 4, 2, 4)						
	    ofmwarserverphysgun_limited:SetText("物理枪限制")
        ofmwarserverphysgun_limited:SetTextColor(whitetext)
        ofmwarserverphysgun_limited:SetFont("oftext")			
	    ofmwarserverphysgun_limited:SetConVar("physgun_limited")										
	    ofmwarserverphysgun_limited:SizeToContents()

        local ofmwarserversbox_playershurtplayers = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_playershurtplayers:Dock(TOP)
        ofmwarserversbox_playershurtplayers:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_playershurtplayers:SetText("允许PVP")
        ofmwarserversbox_playershurtplayers:SetTextColor(whitetext)
        ofmwarserversbox_playershurtplayers:SetFont("oftext")			
	    ofmwarserversbox_playershurtplayers:SetConVar("sbox_playershurtplayers")										
	    ofmwarserversbox_playershurtplayers:SizeToContents()

        local ofmwarserversbox_noclip = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_noclip:Dock(TOP)
        ofmwarserversbox_noclip:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_noclip:SetText("允许穿墙")
        ofmwarserversbox_noclip:SetTextColor(whitetext)
        ofmwarserversbox_noclip:SetFont("oftext")			
	    ofmwarserversbox_noclip:SetConVar("sbox_noclip")										
	    ofmwarserversbox_noclip:SizeToContents()

        local ofmwarserversbox_bonemanip_npc = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_bonemanip_npc:Dock(TOP)
        ofmwarserversbox_bonemanip_npc:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_bonemanip_npc:SetText("允许调整NPC骨骼")
        ofmwarserversbox_bonemanip_npc:SetTextColor(whitetext)
        ofmwarserversbox_bonemanip_npc:SetFont("oftext")			
	    ofmwarserversbox_bonemanip_npc:SetConVar("sbox_bonemanip_npc")										
	    ofmwarserversbox_bonemanip_npc:SizeToContents()

        local ofmwarserversbox_bonemanip_player = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_bonemanip_player:Dock(TOP)
        ofmwarserversbox_bonemanip_player:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_bonemanip_player:SetText("允许调整玩家骨骼")
        ofmwarserversbox_bonemanip_player:SetTextColor(whitetext)
        ofmwarserversbox_bonemanip_player:SetFont("oftext")			
	    ofmwarserversbox_bonemanip_player:SetConVar("sbox_bonemanip_player")										
	    ofmwarserversbox_bonemanip_player:SizeToContents()

        local ofmwarserversbox_bonemanip_misc = ofmpanel1:Add( "DCheckBoxLabel" )
	    ofmwarserversbox_bonemanip_misc:Dock(TOP)
        ofmwarserversbox_bonemanip_misc:DockMargin(2, 4, 2, 4)						
	    ofmwarserversbox_bonemanip_misc:SetText("允许调整其他实体骨骼")
        ofmwarserversbox_bonemanip_misc:SetTextColor(whitetext)
        ofmwarserversbox_bonemanip_misc:SetFont("oftext")			
	    ofmwarserversbox_bonemanip_misc:SetConVar("sbox_bonemanip_misc")										
	    ofmwarserversbox_bonemanip_misc:SizeToContents()

        local ofmwarservert3 = vgui.Create("DLabel", ofmpanel2)
        ofmwarservert3:Dock(TOP)
        ofmwarservert3:DockMargin(2, 8, 2, 8)
        ofmwarservert3:SetText("全局状态")
        ofmwarservert3:SetFont("oftext")
        ofmwarservert3:SetTextColor(importanttextcolor)

        createcheckbox(ofmpanel2,"蚁狮是盟友","ofgs_antlion_allied")
        createcheckbox(ofmpanel2,"关闭HEV冲刺功能","ofgs_suit_no_sprint")
        createcheckbox(ofmpanel2,"启用超级重力枪","ofgs_super_phys_gun")
        createcheckbox(ofmpanel2,"遇到友军时武器降低","ofgs_friendly_encounter")
        createcheckbox(ofmpanel2,"所有玩家都是无敌的","ofgs_gordon_invulnerable")
        createcheckbox(ofmpanel2,"不要在吉普车上生成海鸥","ofgs_no_seagulls_on_jeep")
        createcheckbox(ofmpanel2,"爱莉克斯受伤，无法战斗（EP2）","ofgs_ep2_alyx_injured")
        createcheckbox(ofmpanel2,"NPC开启黑暗模式（EP1）","ofgs_ep_alyx_darknessmode")
        createcheckbox(ofmpanel2,"狩猎者在躲开前跑过来","ofgs_hunters_to_run_over")
        createcheckbox(ofmpanel2,"市民不能被玩家命令","ofgs_citizens_passive")

    end




    local ofmwarserver = vgui.Create("DButton", ofmwar)
    ofmwarserver:SetText("沙盒设定")
    ofmwarserver:Dock(TOP)
    ofmwarserver:DockMargin(0, 0, 0, 0)
    ofmwarserver.DoClick = function()
        ofm_clear()
        ofm_warserver()
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

        local ofmmmdbmf = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbmf:Dock(TOP)
        ofmmmdbmf:DockMargin(2, 4, 2, 4)					
	    ofmmmdbmf:SetText("全亮模式")
        ofmmmdbmf:SetTextColor(whitetext)
        ofmmmdbmf:SetFont("oftext")				
	    ofmmmdbmf:SetConVar("mat_fullbright")									
	    ofmmmdbmf:SizeToContents()

        if ConVarExists("sv_drawmapio") then
            local ofmmmdbio = ofmpanel1:Add( "DCheckBoxLabel" )
            ofmmmdbio:Dock(TOP)
            ofmmmdbio:DockMargin(2, 4, 2, 4)					
            ofmmmdbio:SetText("显示地图实体与输入/输出*")
            ofmmmdbio:SetTextColor(whitetext)
            ofmmmdbio:SetFont("oftext")				
            ofmmmdbio:SetConVar("sv_drawmapio")									
            ofmmmdbio:SizeToContents()
        else
            local ofmmmdbio = vgui.Create("DLabel", ofmpanel1)
            ofmmmdbio:Dock(TOP)
            ofmmmdbio:DockMargin(2, 4, 2, 4)
            ofmmmdbio:SetText("（未挂载）显示地图实体与输入/输出*")
            ofmmmdbio:SetFont("oftext")
            ofmmmdbio:SetTextColor(whitetext) 
        end 

        
        local ofmmmdbskybox = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbskybox:Dock(TOP)
        ofmmmdbskybox:DockMargin(2, 4, 2, 4)					
	    ofmmmdbskybox:SetText("显示地图细节")
        ofmmmdbskybox:SetTextColor(whitetext)
        ofmmmdbskybox:SetFont("oftext")				
	    ofmmmdbskybox:SetConVar("of_skybox")
	    ofmmmdbskybox:SizeToContents()

        local ofmmmdbtrigger = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbtrigger:Dock(TOP)
        ofmmmdbtrigger:DockMargin(2, 4, 2, 4)					
	    ofmmmdbtrigger:SetText("显示地图触发实体")
        ofmmmdbtrigger:SetTextColor(whitetext)
        ofmmmdbtrigger:SetFont("oftext")				
	    ofmmmdbtrigger:SetConVar("showtriggers")									
	    ofmmmdbtrigger:SizeToContents()

        local ofmmmdbshowbudgettexture = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmmmdbshowbudgettexture:Dock(TOP)
        ofmmmdbshowbudgettexture:DockMargin(2, 4, 2, 4)					
	    ofmmmdbshowbudgettexture:SetText("显示材质开销")
        ofmmmdbshowbudgettexture:SetTextColor(whitetext)
        ofmmmdbshowbudgettexture:SetFont("oftext")				
	    ofmmmdbshowbudgettexture:SetConVar("showbudget_texture")									
	    ofmmmdbshowbudgettexture:SizeToContents()
        


        local ofmmmdbfogui = vgui.Create("DButton", ofmpanel1)
        ofmmmdbfogui:SetText("雾气效果菜单")
        ofmmmdbfogui:Dock(TOP)
        ofmmmdbfogui:DockMargin(2, 8, 2, 8)
        ofmmmdbfogui.DoClick = function()
            RunConsoleCommand( "fogui")
        end

        local ofmmmdbcolorcorrectionui = vgui.Create("DButton", ofmpanel1)
        ofmmmdbcolorcorrectionui:SetText("颜色修正菜单")
        ofmmmdbcolorcorrectionui:Dock(TOP)
        ofmmmdbcolorcorrectionui:DockMargin(2, 8, 2, 8)
        ofmmmdbcolorcorrectionui.DoClick = function()
            RunConsoleCommand( "colorcorrectionui")
        end

        local ofmmmdbaishowconnect = vgui.Create("DButton", ofmpanel1)
        ofmmmdbaishowconnect:SetText("显示AI路点")
        ofmmmdbaishowconnect:Dock(TOP)
        ofmmmdbaishowconnect:DockMargin(2, 8, 2, 8)
        ofmmmdbaishowconnect.DoClick = function()
            RunConsoleCommand( "ai_show_connect")
        end

        local ofmmmdbainodes = vgui.Create("DButton", ofmpanel1)
        ofmmmdbainodes:SetText("显示AI导航网格")
        ofmmmdbainodes:Dock(TOP)
        ofmmmdbainodes:DockMargin(2, 8, 2, 8)
        ofmmmdbainodes.DoClick = function()
            RunConsoleCommand( "ai_nodes")
        end

        local ofmmmdbaishowhull = vgui.Create("DButton", ofmpanel1)
        ofmmmdbaishowhull:SetText("显示AI路径规划")
        ofmmmdbaishowhull:Dock(TOP)
        ofmmmdbaishowhull:DockMargin(2, 8, 2, 8)
        ofmmmdbaishowhull.DoClick = function()
            RunConsoleCommand( "ai_show_hull")
        end
         

        
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

        local AddonExistnavmeshmerger = file.Exists("lua/autorun/server/navmesh_merger.lua","GAME")

        if AddonExistnavmeshmerger == true then
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
        else
            local ofmmmnmedatnga = vgui.Create("DLabel", ofmpanel2)
            ofmmmnmedatnga:Dock(TOP)
            ofmmmnmedatnga:DockMargin(2, 4, 2, 4)
            ofmmmnmedatnga:SetText("（未安装）自动合并导航网格*")
            ofmmmnmedatnga:SetFont("oftext")
            ofmmmnmedatnga:SetTextColor(whitetext) 
        end    

        local ofmmmnmedatbc = vgui.Create("DButton", ofmpanel2)
        ofmmmnmedatbc:SetText("构建立方体贴图")
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
        
        local ofmdviptext1 = vgui.Create("DLabel", ofmpanel1)
        ofmdviptext1:Dock(TOP)
        ofmdviptext1:DockMargin(2, 8, 2, 8)
        ofmdviptext1:SetText("UI制作")
        ofmdviptext1:SetFont("oftext")
        ofmdviptext1:SetTextColor(importanttextcolor)

        local ofmdvipvguidrawfocus = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmdvipvguidrawfocus:Dock(TOP)
        ofmdvipvguidrawfocus:DockMargin(2, 4, 2, 4)					
	    ofmdvipvguidrawfocus:SetText("标注UI元素")
        ofmdvipvguidrawfocus:SetTextColor(whitetext)
        ofmdvipvguidrawfocus:SetFont("oftext")				
	    ofmdvipvguidrawfocus:SetConVar("vgui_drawfocus")									
	    ofmdvipvguidrawfocus:SizeToContents()

        local ofmdvipvguidrawtree = ofmpanel1:Add( "DCheckBoxLabel" )
        ofmdvipvguidrawtree:Dock(TOP)
        ofmdvipvguidrawtree:DockMargin(2, 4, 2, 4)					
	    ofmdvipvguidrawtree:SetText("显示UI层次树状图")
        ofmdvipvguidrawtree:SetTextColor(whitetext)
        ofmdvipvguidrawtree:SetFont("oftext")				
	    ofmdvipvguidrawtree:SetConVar("vgui_drawtree")
	    ofmdvipvguidrawtree:SizeToContents()


        local ofmdvipshowschemevisualize = vgui.Create("DButton", ofmpanel1)
        ofmdvipshowschemevisualize:SetText("预览UI字体、边框和颜色")
        ofmdvipshowschemevisualize:Dock(TOP)
        ofmdvipshowschemevisualize:DockMargin(2, 8, 2, 8)
        ofmdvipshowschemevisualize.DoClick = function()
            RunConsoleCommand( "showschemevisualizer")
        end

        local ofmdviptext2 = vgui.Create("DLabel", ofmpanel2)
        ofmdviptext2:Dock(TOP)
        ofmdviptext2:DockMargin(2, 8, 2, 8)
        ofmdviptext2:SetText("重要功能")
        ofmdviptext2:SetFont("oftext")
        ofmdviptext2:SetTextColor(importanttextcolor)

        local ofmdviprl = vgui.Create("DButton", ofmpanel2)
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

        local ofmdviprltext = vgui.Create("DLabel", ofmpanel2)
        ofmdviprltext:Dock(TOP)
        ofmdviprltext:DockMargin(2, 4, 2, 4)
        ofmdviprltext:SetText("左键1秒后重载，右键5秒后重载")
        ofmdviprltext:SetTextColor(whitetext)
        ofmdviprltext:SetFont("oftext")

        local ofmdviprlsm = vgui.Create("DButton", ofmpanel2)
        ofmdviprlsm:SetText("重载Q键菜单")
        ofmdviprlsm:Dock(TOP)
        ofmdviprlsm:DockMargin(2, 8, 2, 8)
        ofmdviprlsm.DoClick = function()
            RunConsoleCommand( "spawnmenu_reload" ) 
        end

        local ofmdviprsnd = vgui.Create("DButton", ofmpanel2)
        ofmdviprsnd:SetText("重载声音")
        ofmdviprsnd:Dock(TOP)
        ofmdviprsnd:DockMargin(2, 8, 2, 8)
        ofmdviprsnd.DoClick = function()
            RunConsoleCommand( "snd_restart" ) 
        end
    end
    
    
    local ofmdvip = vgui.Create("DButton", ofmdv)
    ofmdvip:SetText("插件制作")
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
        surface.PlaySound("of_ui/ui_click_short2.wav")
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

    

    local ofmdvipmainhelpbutton = vgui.Create("DButton", ofmhp)      --使用须知
    ofmdvipmainhelpbutton:SetText("使用须知")
    ofmdvipmainhelpbutton:Dock(TOP)
    ofmdvipmainhelpbutton:DockMargin(0, 0, 0, 0)
    local function ofm_mainhp()
        ofmpanel:Clear()

        local ofmdvipmainhelpmaintext1 = vgui.Create("DLabel", ofmpanel)
        ofmdvipmainhelpmaintext1:Dock(TOP)
        ofmdvipmainhelpmaintext1:DockMargin(2, 8, 2, 4)
        ofmdvipmainhelpmaintext1:SetText("指令百科")
        ofmdvipmainhelpmaintext1:SetFont("oftext")
        ofmdvipmainhelpmaintext1:SetTextColor(importanttextcolor)

        local ofmdvipmainhelptext1 = vgui.Create("DLabel", ofmpanel)
        ofmdvipmainhelptext1:Dock(TOP)
        ofmdvipmainhelptext1:DockMargin(2, 4, 2, 8)
        ofmdvipmainhelptext1:SetText("只记录了我觉得你用得到的指令，建议用ARC放射状菜单绑键搭配使用。")
        ofmdvipmainhelptext1:SetFont("oftext")
        ofmdvipmainhelptext1:SetTextColor(whitetext)

        local ofmdvipmainhelprichtext1 = vgui.Create( "RichText", ofmpanel )
        ofmdvipmainhelprichtext1:Dock( TOP )
        ofmdvipmainhelprichtext1:DockPadding(8, 4, 8, 4)
        ofmdvipmainhelprichtext1:SetSize(xxp, yyp/3) 
        ofmdvipmainhelprichtext1:InsertColorChange( 255, 255, 255, 255 )
        ofmdvipmainhelprichtext1:AppendText("of_menu \n[指令] 打开晦涩弗里曼的工具箱\n")
        -- ofmdvipmainhelprichtext1:AppendText("\nof_god \n[控制台变量] 值为“1”时玩家无敌\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_drawwm \n[控制台变量] 值为“1”时隐藏第三人称\n（某些与玩家动画相关的模组可能会使它失效，只能隐藏第三人称武器模型）\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_cleanup \n[指令] 重置地图\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_clean \n[指令] 清理贴图和尸体（可能无效）\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_removeallweapons \n[指令] 移除玩家武器\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_reload \n[指令] 1秒后重载\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_teleporteyetrace \n[指令] 瞬移到看着的地方，玩大地图时很有用\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_saveasplayerspawn \n[指令] 将当前位置保存为出生点（打战役时这个传送指令最方便）\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_death \n[指令] 瞬移到上次死亡的地方\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_teleportsave \n[指令] 保存位置\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_teleport \n[指令] 瞬移到上次保存的地方\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_overridehealth \n[控制台变量] 值为“1”时覆写玩家血量\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_overridehealthvalue \n[控制台变量] 自定义血量值\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_healthforkills \n[控制台变量] 值为“1”时开启杀敌回血\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_healthforkills_value \n[控制台变量] 杀死NPC或玩家获得的生命值增益量\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_healthregen \n[控制台变量] 值为“1”时开启回血\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_healthregen_speed \n[控制台变量] 回血速度\n")
        ofmdvipmainhelprichtext1:AppendText("\nof_healthregen_delay \n[控制台变量] 回血延迟\n")
        
        
        

        

        local ofmdvipmainhelpmaintext2 = vgui.Create("DLabel", ofmpanel)
        ofmdvipmainhelpmaintext2:Dock(TOP)
        ofmdvipmainhelpmaintext2:DockMargin(2, 8, 2, 4)
        ofmdvipmainhelpmaintext2:SetText("插件支持")
        ofmdvipmainhelpmaintext2:SetFont("oftext")
        ofmdvipmainhelpmaintext2:SetTextColor(importanttextcolor)

        local ofmdvipmainhelptext2 = vgui.Create("DLabel", ofmpanel)
        ofmdvipmainhelptext2:Dock(TOP)
        ofmdvipmainhelptext2:DockMargin(2, 4, 2, 8)
        ofmdvipmainhelptext2:SetText("工具箱中标有“*”的选项需要创意工坊第三方插件支持")
        ofmdvipmainhelptext2:SetFont("oftext")
        ofmdvipmainhelptext2:SetTextColor(whitetext)

        local ofmdvipmainhelprichtext2 = vgui.Create( "RichText", ofmpanel )
        ofmdvipmainhelprichtext2:Dock( TOP )
        ofmdvipmainhelprichtext2:DockPadding(8, 4, 8, 4)
        ofmdvipmainhelprichtext2:SetSize(xxp, yyp/3) 
        ofmdvipmainhelprichtext2:InsertColorChange( 255, 255, 255, 255 )
        ofmdvipmainhelprichtext2:AppendText("ARC9 Weapon Base \nARC9武器包\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2910505837\n")
        ofmdvipmainhelprichtext2:AppendText("\n[ArcCW] Arctic's Customizable Weapons (Base) \nARCCW武器包\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2131057232\n")
        
        ofmdvipmainhelprichtext2:AppendText("\nInfinite Ammo \n无限弹药\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=1875143628\n")
        ofmdvipmainhelprichtext2:AppendText("\nMW/WZ Skydive/Parachute + Infil \n战区降落伞\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2635378860\n")
        ofmdvipmainhelprichtext2:AppendText("\nWeapon Editor & Replacer \n武器编辑替换器\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=933160196\n")
        ofmdvipmainhelprichtext2:AppendText("\nArctic's Radial Binds \nARC放射状菜单\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2391301431\n")
        
        ofmdvipmainhelprichtext2:AppendText("\nRealistic Combine Soldier AI | almost F.E.A.R. AI \nF.E.A.R. AI\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2807525115\n")
        ofmdvipmainhelprichtext2:AppendText("\nSninctbur's Artificial Intelligence Improvements \nSninctbur的AI改进(SAII)\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=1396685893\n")
        ofmdvipmainhelprichtext2:AppendText("\nNPC Model Randomizer / Manager [Combines/Rebels/Metrocops]\nNPC外观随机化\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2875816421\n")
        ofmdvipmainhelprichtext2:AppendText("\nGlobal NPC Group Spawner (Mapwide Auto Spawner)\nZippy的NPC生成器|全图智能生成NPC\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2816773479\n")
        
        ofmdvipmainhelprichtext2:AppendText("\nNPC Navmesh Navigation \nNPC智能寻路|可以让NPC在没有AI NODE的地图中根据导航网格移动\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2905690962\n")
        ofmdvipmainhelprichtext2:AppendText("\nSimple Map IO Viewer \n地图输入输出查看器\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2928263128\n")
        ofmdvipmainhelprichtext2:AppendText("\nNavmesh Optimizer \n导航网格合并工具\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2878197619\n")
        

        
    end

    ofmdvipmainhelpbutton.DoClick = function()
        ofm_clear()
        ofm_mainhp()
    end

    local ofmbugreportbutton = vgui.Create("DButton", ofmhp)      --bug
    ofmbugreportbutton:SetText("更新计划")
    ofmbugreportbutton:Dock(TOP)
    ofmbugreportbutton:DockMargin(0, 0, 0, 0)
    local function ofm_bugreportbutton()
        ofmpanel:Clear()

        local ofmbugreportmaintext1 = vgui.Create("DLabel", ofmpanel)
        ofmbugreportmaintext1:Dock(TOP)
        ofmbugreportmaintext1:DockMargin(2, 8, 2, 4)
        ofmbugreportmaintext1:SetText("待办事项")
        ofmbugreportmaintext1:SetFont("oftext")
        ofmbugreportmaintext1:SetTextColor(importanttextcolor)

        local ofmbugreporttext1 = vgui.Create("DLabel", ofmpanel)
        ofmbugreporttext1:Dock(TOP)
        ofmbugreporttext1:DockMargin(2, 4, 2, 8)
        ofmbugreporttext1:SetText("我对工具箱未来功能的计划以及将要修复的漏洞。")
        ofmbugreporttext1:SetFont("oftext")
        ofmbugreporttext1:SetTextColor(whitetext)

        local ofmbugreportrichtext1 = vgui.Create( "RichText", ofmpanel )
        ofmbugreportrichtext1:Dock( TOP )
        ofmbugreportrichtext1:DockPadding(8, 4, 8, 4)
        ofmbugreportrichtext1:SetSize(xxp, yyp/5) 
        ofmbugreportrichtext1:InsertColorChange( 255, 255, 255, 255 )
        ofmbugreportrichtext1:AppendText("2023.6.19\nNPC替换TFA武器菜单需要改进，现在看起来太乱\n需要添加更多个性化颜色以适应不同UI主题，需要添加菜单透明度选项\n可能增加Tacrp武器包支持（下午1：09已完成）\n受支持但没安装的模组对应的选项在菜单里显示为已开启并没有办法关闭，需要添加颜色进行区分\n")
        ofmbugreportrichtext1:AppendText("\n很久之前 \n（未经证实）工具箱在分辨率不是1920*1080的电脑上可能会出现错位的现象\n")
        
        
        

        

        local ofmbugreportmaintext2 = vgui.Create("DLabel", ofmpanel)
        ofmbugreportmaintext2:Dock(TOP)
        ofmbugreportmaintext2:DockMargin(2, 8, 2, 4)
        ofmbugreportmaintext2:SetText("特别感谢")
        ofmbugreportmaintext2:SetFont("oftext")
        ofmbugreportmaintext2:SetTextColor(importanttextcolor)

        local ofmbugreporttext2 = vgui.Create("DLabel", ofmpanel)
        ofmbugreporttext2:Dock(TOP)
        ofmbugreporttext2:DockMargin(2, 4, 2, 8)
        ofmbugreporttext2:SetSize(xxp, 50*xxs) 
        ofmbugreporttext2:SetText("近期（2023.6.19），我收到了大量关于工具箱的建议及反馈。\n因此，是时候专门开一个栏记录一下了！")
        ofmbugreporttext2:SetFont("oftext")
        ofmbugreporttext2:SetTextColor(whitetext)

        local ofmbugreportrichtext2 = vgui.Create( "RichText", ofmpanel )
        ofmbugreportrichtext2:Dock( TOP )
        ofmbugreportrichtext2:DockPadding(8, 4, 8, 4)
        ofmbugreportrichtext2:SetSize(xxp, yyp*2/5) 
        ofmbugreportrichtext2:InsertColorChange( 255, 255, 255, 255 )
        ofmbugreportrichtext2:AppendText("2024.3.10\n烈焰V2（Steam）\n反馈装备部分自定义武器时prop实体无法按使用键拾起的问题（已修复）\n")
        ofmbugreportrichtext2:AppendText("\n2024.2.5\nPeterwave（B站）\n反馈装备部分自定义武器时prop实体无法按使用键拾起的问题（已修复）\n")
        ofmbugreportrichtext2:AppendText("\n2023.8.10\n雪鞋貓（B站）\n建议增加一键开关无限弹药的选项（已添加）\n")
        ofmbugreportrichtext2:AppendText("\n2023.7.22\n聚乙烯的氮化物（B站）\n建议增加NPC随机替换TFA武器的选项\n")
        ofmbugreportrichtext2:AppendText("\n2023.6.28\nnoob7236（B站）\n建议增加关于伤害类的修改\n")
        ofmbugreportrichtext2:AppendText("\n2023.6.27\n斫青客（B站）\n建议增加快捷调整时间流速的指令绑定\n")
        ofmbugreportrichtext2:AppendText("\n2023.6.18\nGlobex（Steam）\n反馈订阅后没法单独隐藏hud的漏洞（已修复）\n反馈受支持但没安装的模组对应的选项在菜单里显示为已开启并没有办法关闭的漏洞（未修复）\n（这个漏洞虽然不影响功能但是容易误导玩家，应当重视）\n反馈工具箱会导致csm失效的漏洞（修复了。。。应该吧）\n建议增加MWB配件保存，NPC死亡人数过多自动后撤，实体爆炸，NPC自相残杀，优化帧数，全亮模式分级，调整NPC透视距离功能\n（建议有些多w(ﾟДﾟ)w某些功能以后再看吧）\n\nXiaoHappyEnd（B站）\n反馈订阅后没法单独隐藏hud的漏洞（已经修复）\n")
        ofmbugreportrichtext2:AppendText("\n2023.6.16\n爱打电动的汁子（B站）\n建议增加NPC替换TFA武器的选项（完成了一半）\n")
        

        

        
    end

    ofmbugreportbutton.DoClick = function()
        ofm_clear()
        ofm_bugreportbutton()
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
        ofmcb:SetColor( ofbarcolor)
        --ofmcb:SetColor( Color(0, 0, 0, 156) )

        --function ofmcb :DoClick()
        --    ofbarcolor = value
        --end

        function ofmcb :DoRightClick()
            ofbarcolor = Color(72,72,72,255)
            ofm_clear()
            ofm_cs()
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
                local data = { color = value }
                local json = util.TableToJSON(data)
                file.Write("oftk_ofbarcolor.txt", json)
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
                local data = { color = value }
                local json = util.TableToJSON(data)
                file.Write("oftk_importanttextcolor.txt", json)
            end
        end

        -- 现在可以了
        -- local ofmcs3 = vgui.Create("DLabel", ofmcs)
        -- ofmcs3:Dock(TOP)
        -- ofmcs3:DockMargin(2, 8, 2, 8)
        -- ofmcs3:SetText("这只是一个测试功能，目前颜色主题不能保存。")
        -- ofmcs3:SetFont("oftext")
        -- ofmcs3:SetTextColor(whitetext)

        -- local ofmcfb = vgui.Create( "DNumSlider", ofmpanel )
        -- ofmcfb:Dock(TOP)
        -- ofmcfb:DockMargin(2, 4, 2, 4)
        -- ofmcfb:SetText( "工具箱背景透明度" )
        -- ofmcfb:SetMin( 0 )
        -- ofmcfb:SetMax( 256 )
        -- ofmcfb:SetDecimals( 0 )
        -- ofmcfb:SetConVar( "of_menu_customize_faded_black" )

        -- local ofmcpcl = vgui.Create( "DNumSlider", ofmpanel )
        -- ofmcpcl:Dock(TOP)
        -- ofmcpcl:DockMargin(2, 4, 2, 4)
        -- ofmcpcl:SetText( "工具箱页面透明度" )
        -- ofmcpcl:SetMin( 0 )
        -- ofmcpcl:SetMax( 256 )
        -- ofmcpcl:SetDecimals( 0 )
        -- ofmcpcl:SetConVar( "of_menu_customize_panel" )



        
    end
    
    local ofmstcolorbutton = vgui.Create("DButton", ofmst)      --设置菜单
    ofmstcolorbutton:SetText("颜色主题")
    ofmstcolorbutton:Dock(TOP)
    ofmstcolorbutton:DockMargin(0, 0, 0, 0)
    ofmstcolorbutton.DoClick = function()
        ofm_clear()
        ofm_cs()
    end
    



    
end



local function OfMenuToggle()
	if IsValid( of_menu ) then of_menu:Close() else of_menu_open() end
end

concommand.Add( "of_menu", OfMenuToggle )

list.Set("DesktopWindows", "oftoolmenuc", {
    title = "晦涩弗里曼的工具箱",
    icon = "oftoollogo/oftoollogo.png",
    init = function(icon, window)
        RunConsoleCommand( "of_menu")
        
    end
})





