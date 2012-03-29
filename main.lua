-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local newPage = display.newImage("backgroundC.png") -- The new revealed page

local mainPage = display.newImage("backgroundA.png") -- The original page
local newMask = graphics.newMask ("mask1.png")
mainPage:setMask( newMask )
mainPage.isHitTestMasked = false

local mainShadow = display.newImage("mainshadow.png") -- The shadow that is cast upon mainPage
local newMask3 = graphics.newMask ("mask1.png")
mainShadow:setMask( newMask3 )
mainShadow.y = display.contentHeight / 2
mainShadow.isVisible = false

local backPage = display.newImage("backgroundB.png") -- The page that is displayed on the back side of mainPage
local newMask2 = graphics.newMask ("mask1.png")
backPage:setMask( newMask2 )

local curlShadow = display.newImage("curlshadow.png") -- The shadow over backPage that gives it a curled appearance.
curlShadow.y = display.contentHeight / 2
curlShadow.yScale = 150
curlShadow.xReference = curlShadow.contentWidth / 2
curlShadow.xScale = 0
curlShadow.isVisible = false

local newShadow = display.newImage("newshadow.png") -- The shadow that is cast upon newPage
newShadow.y = display.contentHeight / 2
newShadow.yScale = 150
newShadow.xReference = -1 * newShadow.contentWidth / 2
newShadow.xScale = 0
newShadow.isVisible = false

local fingerX = display.contentWidth
local fingerY = 0
local startX = 0
local startY = 0
local maskRot = 0
local isDrag = false

local function onPageSwipe( self, event )
	local phase = event.phase
	fingerX = event.x
	fingerY = event.y
	if phase == "began" then
		-- Make Shadows Visible
		mainShadow.isVisible = true
		curlShadow.isVisible = true
		newShadow.isVisible = true
		
		display.getCurrentStage():setFocus( self )
		self.isFocus = true
		startX = event.x
		startY = event.y
		isDrag = true
	elseif self.isFocus then
			display.getCurrentStage():setFocus( nil )
			self.isFocus = nil
	end
	if phase == "ended" or phase == "cancelled" then
			isDrag = false
	end
	return true
end

local function maskFrame ()

	if isDrag == false then
	
		-- Upon release this either continues to turn the page or resets it to normal
		if fingerX < display.contentWidth and fingerX > display.contentWidth / 2 then
			fingerX = fingerX + 20
			fingerY = (startY + fingerY) / 2
		elseif fingerX > -1 * display.contentWidth and fingerX < display.contentWidth / 2 then
			fingerX = fingerX - 20
			fingerY = (startY + fingerY) / 2
		end
		
		if fingerX < -1 * display.contentWidth then
			fingerX = -1 * display.contentWidth
			fingerY = startY
			mainShadow.isVisible = false
			curlShadow.isVisible = false
			newShadow.isVisible = false
		end
			
		if fingerX > display.contentWidth then
			fingerX = display.contentWidth
			fingerY = startY
			mainShadow.isVisible = false
			curlShadow.isVisible = false
			newShadow.isVisible = false
		end
	end
	
	tempX = (fingerX + (display.contentWidth - fingerX)/2)
	maskRot = math.deg (math.atan2 (startY - fingerY, display.contentWidth - tempX))
	
	mainPage.maskRotation = maskRot / 6
	mainPage.maskX = tempX - display.contentWidth / 2
	
	backPage.rotation = maskRot / 3
	backPage.x = tempX
	backPage.xReference =  display.contentWidth/2 - tempX
	backPage.maskRotation = maskRot / -6
	backPage.maskX = display.contentWidth / 2 - tempX

	mainShadow.rotation = maskRot / 3
	mainShadow.x = tempX + 10 * (fingerX / display.contentWidth)
	mainShadow.xReference =  display.contentWidth/2 - tempX
	mainShadow.maskRotation = maskRot / -6
	mainShadow.maskX = display.contentWidth / 2 - tempX - 10 * (fingerX / display.contentWidth)

	curlShadow.rotation = maskRot / 6
	curlShadow.x = tempX
	curlShadow.xScale = 1 - fingerX / display.contentWidth
	
	newShadow.rotation = maskRot / 6
	newShadow.x = tempX
	newShadow.xScale = 1 - fingerX / display.contentWidth / 3
end

local function Touch(event)
	
end

local function OnFrame ( event )
	maskFrame ()
end

--
-- Listeners

Runtime:addEventListener( "enterFrame", OnFrame )

mainPage.touch = onPageSwipe
mainPage:addEventListener( "touch", mainPage )