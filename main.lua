START_Y = 224

MOAISim.openWindow ( "Kitteh! Go!", 320, 480 )

viewport = MOAIViewport.new ()
viewport:setSize ( 320, 480 )
viewport:setScale ( 320, -480 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

screenWidth, screenHeight = MOAIEnvironment.getScreenSize ()
print ( 'screen:\t', screenWidth, screenHeight )

viewWidth, viewHeight = MOAIEnvironment.getViewSize ()
print ( 'view:\t', viewWidth, viewHeight )

if MOAIEnvironment.isRetinaDisplay () then
	print ( 'retina display' )
end


grid = MOAIGrid.new ()
grid:setSize ( 10, 15, 32, 32 )

grid:setRow ( 1, 	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 )
grid:setRow ( 2,	0x01, 0x01, 0x01, 0x01, 0x01, 0x03, 0x01, 0x01, 0x01, 0x01 )
grid:setRow ( 3,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow ( 4,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow ( 5,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow ( 6,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow ( 7,	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02 )
grid:setRow ( 8,	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02 )
grid:setRow ( 9,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow (10,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow (11,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow (12,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow (13,	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
grid:setRow (14,	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 )
grid:setRow (15,	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 )

tileDeck = MOAITileDeck2D.new ()
tileDeck:setTexture ( "tiles.png" )
tileDeck:setSize ( 4, 1 )

background = MOAIProp2D.new ()
background:setDeck ( tileDeck )
background:setGrid ( grid )
background:setLoc ( -160, -240 )
layer:insertProp ( background )

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "cathead.png" )
gfxQuad:setRect ( -16, -16, 16, 16 )
gfxQuad:setUVRect ( 0, 0, 1, 1 )

kitteh = MOAIProp2D.new ()
kitteh:setDeck ( gfxQuad )
kitteh:setLoc ( 16, START_Y )
layer:insertProp ( kitteh )

gameWon = false

function clickCallback ( down )
	if down then
		kitteh:moveScl ( -0.25, -0.25, 0.125, MOAIEaseType.EASE_IN )
	else
		kitteh:moveScl ( 0.25, 0.25, 0.125, MOAIEaseType.EASE_IN )
		if gameWon then
			kitteh:moveRot ( 360, 1.5, MOAIEaseType.EASE_IN )
		else
			local x, y = kitteh:getLoc ()
			if ( y > -208 ) then
				kitteh:seekLoc ( x, y-32, 0.125, MOAIEaseType.LINEAR )			
				cx = (x + 16 + 160) / 32
				cy = (y + 224) / 32
				cell = grid:getTile ( cx, cy )
				if cell == 3 then
					gameWon = true
					kitteh:moveRot ( 360, 1.5 )				
				end
			end
		end
	end
end


MOAIInputMgr.device.touch:setCallback ( 
  function ( eventType, idx, x, y, tapCount )
    if eventType == MOAITouchSensor.TOUCH_DOWN then
      clickCallback ( true )
    elseif eventType == MOAITouchSensor.TOUCH_UP then
      clickCallback ( false )
    end
  end
)
