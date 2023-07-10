CreateConVar( "of_overridehealth", "0",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )	--覆写玩家血量
CreateConVar( "of_overridehealthvalue", "100",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )	--覆写血量值


CreateConVar("of_healthforkills", "0", {FCVAR_NONE}, "开启杀敌回血")
local of_addhealth = CreateConVar("of_healthforkills_value", "20", {FCVAR_NONE}, "杀死NPC或玩家获得的生命值增益量")

CreateConVar("of_healthregen", 0, FCVAR_ARCHIVE, "是否开启回血")
CreateConVar("of_healthregen_speed", 1, FCVAR_ARCHIVE, "回血速度")
CreateConVar("of_healthregen_delay", 5, FCVAR_ARCHIVE, "延迟")

local ConflictExists1 = file.Exists("lua/autorun/healthforkills.lua","GAME")
local ConflictExists2 = file.Exists("lua/autorun/healthregen.lua","GAME")

if ConflictExists1 == false and ConflictExists2 == false then

    hook.Add("PlayerSpawn", "of_overridehealthhook", function(ply)  --覆写生命值功能
        if GetConVar("of_overridehealth"):GetInt() == 1 then
            local OverrideHealthValue = GetConVar("of_overridehealthvalue"):GetInt()
            timer.Simple( 0.01, function() 
                ply:SetHealth(OverrideHealthValue)	--覆写玩家生命值
            end ) 
        end
    end)



    hook.Add("PlayerDeath", "AddHealth", function(victim, inflictor, attacker)
        -- 检查攻击者是否是有效的玩家且不与受害者相同
        if IsValid(attacker) and attacker:IsPlayer() and attacker ~= victim then
            local ADDHEALTH = of_addhealth:GetInt()
            -- 增加攻击者的生命值
            if GetConVar("of_healthforkills"):GetInt() == 1 then
                if GetConVar("of_overridehealth"):GetInt() == 1 then
                    local OverrideHealthValue = GetConVar("of_overridehealthvalue"):GetInt()
                    attacker:SetHealth(math.min(attacker:Health() + ADDHEALTH, OverrideHealthValue))
                else
                    attacker:SetHealth(math.min(attacker:Health() + ADDHEALTH, attacker:GetMaxHealth()))
                end
            end
        end
    end)

    hook.Add("OnNPCKilled", "AddHealth", function(victim, attacker, inflictor)
        if attacker:IsPlayer() then
            local ADDHEALTH = of_addhealth:GetInt()
            if GetConVar("of_healthforkills"):GetInt() == 1 then
                if GetConVar("of_overridehealth"):GetInt() == 1 then
                    local OverrideHealthValue = GetConVar("of_overridehealthvalue"):GetInt()
                    attacker:SetHealth(math.min(attacker:Health() + ADDHEALTH, OverrideHealthValue))
                else
                    attacker:SetHealth(math.min(attacker:Health() + ADDHEALTH, attacker:GetMaxHealth()))
                end
            end
        end
    end)



    local function Think()
        if GetConVar( "of_overridehealthvalue" ):GetInt() != OverrideHealthValue then
            OverrideHealthValue = GetConVar( "of_overridehealthvalue" ):GetInt()
        end
        local speed = 1 / GetConVarNumber("of_healthregen_speed")
        local time = FrameTime()
        if GetConVar("of_healthregen"):GetInt() == 1 then
            for _, ply in pairs(player.GetAll()) do
                if ply:Alive() then
                    local health = ply:Health()
                    if health < (ply.LastHealth or 0) then
                        ply.HealthRegenNext = CurTime() + GetConVarNumber("of_healthregen_delay")
                    end
                    if CurTime() > (ply.HealthRegenNext or 0) then
                        ply.HealthRegen = (ply.HealthRegen or 0) + time
                        if ply.HealthRegen >= speed then
                            local add = math.floor(ply.HealthRegen / speed)
                            ply.HealthRegen = ply.HealthRegen - (add * speed)
                            if GetConVar("of_overridehealth"):GetInt() == 1 then
                                if health < OverrideHealthValue or speed < 0 then
                                    ply:SetHealth(math.min(health + add, OverrideHealthValue))
                                end
                            else
                                local playermaxhealth = ply:GetMaxHealth()
                                if health < playermaxhealth or speed < 0 then
                                    ply:SetHealth(math.min(health + add, playermaxhealth))
                                end
                                
                            end
                        end
                    end
                    ply.LastHealth = ply:Health()
                end
            end
        end
    end
    hook.Add( "Think", "HealthRegen.Think", Think )
end
