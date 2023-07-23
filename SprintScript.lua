local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

player.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	local maxStamina = 100
	local currentStamina = maxStamina
	local staminaGUI = player:WaitForChild("PlayerGui"):WaitForChild("StaminaGUI")
	local staminaFrame2 = staminaGUI:WaitForChild("StaminaFrame2")
	staminaFrame2.AnchorPoint = Vector2.new(1, 0)

	local regenerating = false
	local regenBound = false

	local function updateStamina(stamina)
		if stamina <= 0 then
			staminaFrame2.Size = UDim2.new(0, 0, 0, 11) --- the bar size update only where it says 11
		else
			staminaFrame2.Size = UDim2.new(0, (482 * stamina / maxStamina), 0, 11) -- the bar size
		end
	end

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			if currentStamina > 0 then
				humanoid.WalkSpeed = 22 -- Sprint Speed
				regenerating = false
				if regenBound then
					RunService:UnbindFromRenderStep("RegenStamina")
					regenBound = false
				end
				RunService:BindToRenderStep("DrainStamina", Enum.RenderPriority.Camera.Value, function()
					if currentStamina > 0 then
						currentStamina = currentStamina - 0.7 -- Decrease or increase the stamina usage
						updateStamina(currentStamina)
					else
						RunService:UnbindFromRenderStep("DrainStamina")
						humanoid.WalkSpeed = 16
					end
				end)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			humanoid.WalkSpeed = 16
			RunService:UnbindFromRenderStep("DrainStamina")
			if not regenerating and not regenBound then
				regenerating = true
				regenBound = true
				wait(currentStamina <= 0 and 1 or 0.3)
				RunService:BindToRenderStep("RegenStamina", Enum.RenderPriority.Camera.Value, function()
					if currentStamina < maxStamina then
						currentStamina = currentStamina + 0.6  -- Increase or decrease regeneration rate
						updateStamina(currentStamina)
					else
						regenerating = false
						regenBound = false
						RunService:UnbindFromRenderStep("RegenStamina")
					end
				end)
			end
		end
	end)
end)
