local Players = game:GetService("Players")

local function shouldRemovePlayer(player)
	-- Replace with server-trusted checks only.
	-- Never trust client-provided claims about executor, ownership, stats, etc.
	return false
end

Players.PlayerAdded:Connect(function(player)
	if shouldRemovePlayer(player) then
		player:Kick("Access denied.")
	end
end)
