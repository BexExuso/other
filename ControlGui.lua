local HttpService = game:GetService("HttpService")
local secret = "ExusoProtect10"

local function notify(title, text)
	pcall(function()
		game.StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 5
		})
	end)
end

local data = _G._secondaryExuso
local userKey = _G.__userKey

if not data or not data.nonce or not data.timestamp or not data.signature or not data.userKey or not userKey then
	notify("Exuso Hub", "❌ Please run this script using the official Exuso Hub loader.")
	return
end

if data.userKey ~= userKey then
	notify("Exuso Hub", "❌ Invalid user key. Use the official exuso hub loader.")
	return
end

local token = data.nonce .. ":" .. data.timestamp .. ":" .. userKey
local signatureCheck = HttpService:UrlEncode(token .. secret)

if signatureCheck ~= data.signature then
	notify("Exuso Hub", "❌ Signature check failed. Use the official exuso hub loader.")
	return
end

_G._secondaryExuso = nil
_G.__userKey = nil

notify("Exuso Hub", "✅ Verification successful. Script is now loading...")

local p=game:GetService("Players")
local r=game:GetService("ReplicatedStorage")
local rs=game:GetService("RunService")
local u=game:GetService("UserInputService")
local l=p.LocalPlayer
local c=workspace.CurrentCamera
local f=workspace:WaitForChild("Football")
local a=r.Packages.Knit.Services.AbilityService.RE
local ctrl=false
local fired=false
local vel=70
local minV=20
local maxV=170
local allow=true
local g=Instance.new("ScreenGui")
g.Name="BallControlGui"
g.ResetOnSpawn=false
g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
g.Parent=l:WaitForChild("PlayerGui")
local ct=Instance.new("TextButton")
ct.Name="ControlToggle"
ct.Size=UDim2.new(0,120,0,40)
ct.Position=UDim2.new(0.05,0,0.7,0)
ct.AnchorPoint=Vector2.new(0,0)
ct.BackgroundColor3=Color3.fromRGB(200,0,0)
ct.TextColor3=Color3.fromRGB(255,255,255)
ct.Text="Control (OFF)"
ct.TextScaled=true
ct.Font=Enum.Font.GothamBold
ct.ZIndex=5
ct.Parent=g
local sf=Instance.new("Frame")
sf.Size=UDim2.new(0.6,0,0.03,0)
sf.Position=UDim2.new(0.5,0,0.65,0)
sf.AnchorPoint=Vector2.new(0.5,0.5)
sf.BackgroundTransparency=1
sf.Visible=false
sf.ZIndex=10
sf.Parent=g
local sb=Instance.new("Frame")
sb.Size=UDim2.new(1,0,1,0)
sb.BackgroundColor3=Color3.fromRGB(220,220,220)
sb.BorderSizePixel=0
sb.ZIndex=10
sb.Parent=sf
local sk=Instance.new("Frame")
sk.Name="SliderKnob"
sk.Size=UDim2.new(0,30,0,30)
sk.Position=UDim2.new(0.5,-15,0.5,-15)
sk.BackgroundColor3=Color3.fromRGB(255,255,255)
sk.BorderSizePixel=0
sk.ZIndex=11
sk.Parent=sb
sk.Active=true
sk.Draggable=true
local sd=Instance.new("TextLabel")
sd.Size=UDim2.new(0,100,0,30)
sd.Position=UDim2.new(0.5,-50,0,-40)
sd.BackgroundTransparency=1
sd.TextColor3=Color3.fromRGB(255,255,255)
sd.TextScaled=true
sd.Font=Enum.Font.GothamBold
sd.Text=""
sd.ZIndex=11
sd.Parent=sf
local function us()sd.Text=tostring(math.floor(vel)).." Speed" end
local function uv()local B=sb.AbsolutePosition.X;local S=sb.AbsoluteSize.X;local K=sk.AbsolutePosition.X+sk.AbsoluteSize.X/2;local I=math.clamp(K,B,B+S);local P=(I-B)/S;vel=minV+P*(maxV-minV);us()end
local function tc()if not allow then for _,pl in ipairs(p:GetPlayers())do if pl.Character then local v=pl.Character:FindFirstChild("Values");local h=v and v:FindFirstChild("HasBall");if h and h.Value==true then return end end end end
if not ctrl and not fired then for _,op in ipairs(p:GetPlayers())do if op~=l and op.Character and op.Character:FindFirstChild("HumanoidRootPart")then local x={[1]="OneTwo",[2]=op.Character.HumanoidRootPart}a.Ability:FireServer(unpack(x))end end;fired=true end
ctrl=not ctrl;ct.Text="Control ("..(ctrl and "ON" or "OFF")..")";ct.BackgroundColor3=ctrl and Color3.fromRGB(0,200,0)or Color3.fromRGB(200,0,0);sf.Visible=ctrl
if ctrl then c.CameraSubject=f;c.CameraType=Enum.CameraType.Custom;uv()else if l.Character and l.Character:FindFirstChild("Humanoid")then c.CameraSubject=l.Character.Humanoid end;fired=false end end
local fy=sk.Position.Y
sk:GetPropertyChangedSignal("Position"):Connect(function()if ctrl then local B=sb.AbsolutePosition.X;local S=sb.AbsoluteSize.X;local K=sk.Size.X.Offset;local C=sk.AbsolutePosition.X+K/2;local mX=B+K/2;local MX=B+S-K/2;local cX=math.clamp(C,mX,MX);local nX=cX-B-K/2;sk.Position=UDim2.new(0,nX,fy.Scale,fy.Offset);uv()end end)
ct.MouseButton1Click:Connect(tc)
u.InputBegan:Connect(function(inp,gp)if not gp and inp.KeyCode==Enum.KeyCode.F then tc()end end)
rs.RenderStepped:Connect(function()if ctrl then f.AssemblyLinearVelocity=c.CFrame.LookVector*vel end end)

