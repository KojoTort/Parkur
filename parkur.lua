
local wallJumpEnabled = true
local maxWallJumps = 4

hook.Add("KeyPress", "WallJump", function(pl, k)
    if not wallJumpEnabled then return end
    if k ~= IN_JUMP then return end

    local tr = util.TraceLine(pl:GetShootPos(), pl:GetShootPos() + pl:GetAimVector() * 20, pl)
    if tr.Hit and tr.HitNormal:DotProduct(pl:GetVelocity():GetNormalized()) > 0.7 then
        local wallNormal = tr.HitNormal
        local vel = pl:GetVelocity()
        vel.z = 0
        vel = vel + wallNormal * 200 

        pl:SetVelocity(vel)
        pl.WallJumps = (pl.WallJumps or 0) + 1
    end
end)

hook.Add("Think", "WallJumpReset", function()
    for _, pl in ipairs(player.GetAll()) do
        if pl:IsOnGround() then
            pl.WallJumps = 0
        end
    end
end)

hook.Add("PlayerTick", "WallJumpLimit", function(pl)
    if pl.WallJumps and pl.WallJumps >= maxWallJumps then
        pl.WallJumps = maxWallJumps
    end
end)