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

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "cathead.png" )
gfxQuad:setRect ( -16, -16, 16, 16 )
gfxQuad:setUVRect ( 0, 0, 1, 1 )

kitteh = MOAIProp2D.new ()
kitteh:setDeck ( gfxQuad )
kitteh:setLoc ( 0, START_Y )
layer:insertProp ( kitteh )

function clickCallback ( down )
	if down then
		kitteh:moveScl ( -0.25, -0.25, 0.125, MOAIEaseType.EASE_IN )
	else
		kitteh:moveScl ( 0.25, 0.25, 0.125, MOAIEaseType.EASE_IN )
		local x, y = kitteh:getLoc ()
		print ( 'kitteh:loc:\t', x, y )
		kitteh:seekLoc ( x, y-32, 0.125, MOAIEaseType.EASE_IN )
	end
end


MOAIInputMgr.device.touch:setCallback ( 
  function ( eventType, idx, x, y, tapCount )
    -- pointerCallback ( x, y )

    if eventType == MOAITouchSensor.TOUCH_DOWN then
      clickCallback ( true )
    elseif eventType == MOAITouchSensor.TOUCH_UP then
      clickCallback ( false )
    end
  end
)
