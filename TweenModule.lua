local SelectionService = game:GetService('Selection')
local ChangeHistory = game:GetService('ChangeHistoryService')

local PluginService = require(9622376900)

local WidgetFrame = PluginService.new()

local toolbar = plugin:CreateToolbar('Ro-Tweener')

local newTween = toolbar:CreateButton('New Tween', 'Creates a new tween', 'rbxassetid://5650878050')
local testTween = toolbar:CreateButton('Test Tween', 'Tests your new tween', 'rbxassetid://368173715')
local createTween = toolbar:CreateButton('Create TweenScript', 'Creates a new script for your tween!', 'rbxassetid://13546048')

local tweenVal = false
local canTest = false

local ChosenStyle = Enum.EasingStyle.Linear

local TweenValues = {
	['Time'] = 1,
	['Styles'] = {
		['Linear'] = Enum.EasingStyle.Linear,
		['Elastic'] = Enum.EasingStyle.Elastic,
		['Cubic'] = Enum.EasingStyle.Cubic,
		['Bounce'] = Enum.EasingStyle.Bounce,
		['Back'] = Enum.EasingStyle.Back,
		['Sine'] = Enum.EasingStyle.Sine,
		['Quad'] = Enum.EasingStyle.Quad,
		['Quart'] = Enum.EasingStyle.Quart,
		['Quint'] = Enum.EasingStyle.Quint,
		['Circular'] = Enum.EasingStyle.Circular,
		['Exponential'] = Enum.EasingStyle.Exponential
	},
	['Directions'] = {
		['In'] = Enum.EasingDirection.In,
		['Out'] = Enum.EasingDirection.Out,
		['InOut'] = Enum.EasingDirection.InOut
	},
	Repeat = 0,
	Reverse = false,
	DelayTime = 0
}

local NewTweenWidgetInfo = PluginService.CreateDockWidget()

local TweenWidget = plugin:CreateDockWidgetPluginGui('TweenSettings', NewTweenWidgetInfo)
TweenWidget.Title = 'Tween Settings'
TweenWidget.Enabled = false

WidgetFrame.Parent = TweenWidget

local Values
local OldPart
local Sel1

local ChangingVals = WidgetFrame.ValuesBox
local values__ = WidgetFrame.ValuesLabel
local TweenStyles = WidgetFrame.StylesBox
local TweenDirections = WidgetFrame.DirectionsBox
local Dir = WidgetFrame.DirectionsLabel
local Style = WidgetFrame.StyleLabel
local TweenRepeat = WidgetFrame.RepeatBox
local TweenDelay = WidgetFrame.DelayBox
local TweenTime = WidgetFrame.TimeBox
local TweenReverse = WidgetFrame.ReverseBox

local ChosenDirection = Enum.EasingDirection.In
local ChosenStyle = Enum.EasingStyle.Linear

local values 

ChangingVals.FocusLost:Connect(function(enter)
	if enter then
		local newValues = PluginService:UpdatePartValues(Sel1, values, ChangingVals, OldPart, values__)
		
		values = newValues
	end
end)

local frame = Instance.new('Frame')
frame.Size = UDim2.new(0.6,0,0.45,0)
frame.Visible = false
frame.Position = TweenStyles.Position + UDim2.new(0.2,0,0.02,0)
frame.Parent = TweenWidget

local newFrame = frame:Clone()
newFrame.Position = TweenDirections.Position + UDim2.new(0.2,0,0.02,0)
newFrame.Parent = TweenWidget
newFrame.Size = UDim2.new(0.6,0,0.2,0)

TweenDirections.Activated:Connect(function()
	newFrame.Visible = not newFrame.Visible

	if newFrame.Visible then
		newFrame:ClearAllChildren()

		local UiList = Instance.new('UIListLayout')
		UiList.Parent = newFrame
		UiList.FillDirection = Enum.FillDirection.Vertical
		UiList.Padding = UDim.new(0.025,0)
		for DirectionName, Direction in next, TweenValues.Directions do
			local Textp = Instance.new('TextButton')
			Textp.Text = DirectionName
			Textp.Parent = newFrame
			Textp.Position = UDim2.new(0,0,0.2,0)
			Textp.TextScaled = true
			Textp.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
			Textp.TextColor3 = Color3.fromRGB(255, 255, 255)
			Textp.Size = UDim2.new(1,0,0.4,0)

			Textp.Activated:Connect(function()
				ChosenDirection = Enum.EasingDirection[Textp.Text]

				Dir.Text = 'Direction: ' .. ChosenDirection.Name

				newFrame.Visible = false
			end)
		end
	end
end)

TweenStyles.Activated:Connect(function()
	frame.Visible = not frame.Visible

	if frame.Visible then
		frame:ClearAllChildren()
		local UiList = Instance.new('UIListLayout')
		UiList.Parent = frame
		UiList.FillDirection = Enum.FillDirection.Vertical
		UiList.Padding = UDim.new(0.025,0)
		for StyleName, Style_ in next, TweenValues.Styles do
			local Textp = Instance.new('TextButton')
			Textp.Text = StyleName
			Textp.Parent = frame
			Textp.Position = UDim2.new(0,0,0.2,0)
			Textp.TextScaled = true
			Textp.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
			Textp.TextColor3 = Color3.fromRGB(255, 255, 255)
			Textp.Size = UDim2.new(1,0,0.07,0)
			
			Textp.Activated:Connect(function()
				ChosenStyle = Enum.EasingStyle[Textp.Text]

				Style.Text = 'Style: ' .. ChosenStyle.Name

				frame.Visible = false
			end)
		end
	end
end)

TweenRepeat.FocusLost:Connect(function(input)
	if input then
		TweenRepeat.Text = TweenRepeat.Text:gsub('%D+','')
	end
end)

TweenTime.FocusLost:Connect(function(input)
	if input then
		TweenTime.Text = TweenTime.Text:gsub('%D+','')
	end
end)

TweenDelay.FocusLost:Connect(function(input)
	if input then
		TweenDelay.Text = TweenDelay.Text:gsub('%D+','')
	end
end)

local function CreateNewTween()
	local Selection = SelectionService:Get()
	Sel1 = Selection[1]

	print(Sel1)
	if not tweenVal then
		tweenVal = true
		TweenWidget.Enabled = true
	else
		tweenVal = false
		TweenWidget.Enabled = false
	end

	print(tweenVal, OldPart)

	if Sel1:IsA("BasePart") and tweenVal == true then
		canTest = true
		OldPart = Sel1:Clone()
		OldPart.Parent = workspace
		OldPart.Transparency = 0.5
		OldPart.Name = Sel1.Name..'CustomTweenClone'
		OldPart.CFrame = Sel1.CFrame
		
		if values ~= nil then
			local _Values = {}

			for i,v in pairs(values) do
				_Values[v] = OldPart[v]
			end

			values = _Values
		end
		
		ChangeHistory:SetWaypoint('Created new Tween Part')
	elseif tweenVal == false and OldPart ~= nil then
		canTest = false

		OldPart:Destroy()
	end
end

local TestDebounce = false

local function TestTween()
	local newValues = PluginService:UpdatePartValues(Sel1, values, ChangingVals, OldPart, values__)

	values = newValues
	
	Sel1 = SelectionService:Get()[1]
	print(canTest,game:GetService('HttpService'):JSONEncode(values),Sel1,TestDebounce)
	if canTest and values ~= nil and Sel1 and not Sel1.Name:match('CustomTweenClone') and not TestDebounce then
		TestDebounce = true
		local OldValues = {}

		for i,v in pairs(values) do
			OldValues[i] = Sel1[i]
		end

		for i,v in pairs(values) do
			if i == 'Color' and not type(v) == 'color3' then
				local colors = {
					R = tonumber(v:split(', ')[1]),
					G = tonumber(v:split(', ')[2]),
					B = tonumber(v:split(', ')[3])
				}
				values[i] = Color3.fromRGB(colors.R,colors.G,colors.B) 
			end
		end
		print('e')
		local reverse_
		if TweenReverse.Text:lower() == 'true' then
			reverse_ = true
		else
			reverse_ = false
		end

		local NewTestTween = game:GetService('TweenService'):Create(Sel1, TweenInfo.new(tonumber(TweenTime.Text),ChosenStyle,ChosenDirection, tonumber(TweenRepeat.Text), reverse_, tonumber(TweenDelay.Text)), values)

		NewTestTween:Play()

		NewTestTween.Completed:Wait()

		for i,v in pairs(OldValues) do
			Sel1[i] = OldValues[i]
		end

		TestDebounce = false
	end
end

local function CreateTweenScript()
	if values == nil then
		return warn('Sorry it seems the Table of values has resulted in Nil.')
	end
	local reverse_
	if TweenReverse.Text:lower() == 'true' then
		reverse_ = 'true'
	else
		reverse_ = 'false'
	end
	
	local STRING = ''
	local function getVal()
		for i,v in pairs(values) do
			if i == 'CFrame' then
				STRING = STRING .. '["' .. i .. '"] = CFrame.new(' .. tostring(v) .. '),\n'
			elseif i == 'Position' or i == 'Orientation' or i == 'Size' then
				STRING = STRING .. '["' .. i .. '"] = Vector3.new(' .. tostring(v) .. '),\n'
			elseif i == 'Color' then
				STRING = STRING .. '["' .. i .. '"] = Color3.new(' .. tostring(v) .. '),\n'
			else
				STRING = STRING .. '["' .. i .. '"] = ' .. tostring(v) .. ',\n'
			end
		end
		
		return STRING
	end
	
	STRING = getVal()
	print(STRING)
	
	local NewScript = Instance.new('Script')
	NewScript.Name = OldPart.Name..'_TweenScript'
	NewScript.Parent = Sel1
	NewScript.Source = [[
--> Thank you for using Ro-Tweener! <--

local TweenService = game:GetService('TweenService')

local values = {]] .. STRING .. [[}

local NewTween = TweenService:Create(workspace:FindFirstChild("]] .. NewScript.Parent.Name .. '", true), TweenInfo.new(' .. 
		tonumber(TweenTime.Text) .. ', ' .. 
		'Enum.EasingStyle.' .. ChosenStyle.Name .. ', ' .. 
		'Enum.EasingDirection.' .. ChosenDirection.Name .. ', ' .. 
		tonumber(TweenRepeat.Text) .. ', ' .. 
		reverse_ .. ', ' .. 
		tonumber(TweenDelay.Text) .. '), values)'..[[
		
NewTween:Play()
]]
	OldPart:Destroy()
end

newTween.Click:Connect(CreateNewTween)
testTween.Click:Connect(TestTween)
createTween.Click:Connect(CreateTweenScript)