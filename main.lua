START_Y = 224

MOAISim.openWindow ( "Kitteh! Go!", 320, 480 )

viewport = MOAIViewport.new ()
if MOAIEnvironment.isRetinaDisplay () then
	viewport:setSize ( 640, 960 )
else
	viewport:setSize ( 320, 480 )
end
viewport:setScale ( 320, -480 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

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

carQuad = MOAIGfxQuad2D.new ()
carQuad:setTexture ( "car.png" )
carQuad:setRect ( -24, -16, 24, 16 )
carQuad:setUVRect ( 0, 0, 1, 1 )

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "cathead.png" )
gfxQuad:setRect ( -16, -16, 16, 16 )
gfxQuad:setUVRect ( 0, 0, 1, 1 )

kitteh = MOAIProp2D.new ()
kitteh.alive = true
kitteh:setDeck ( gfxQuad )
kitteh:setLoc ( 16, START_Y )
layer:insertProp ( kitteh )

gameWon = false

cars = {}

math.randomseed( os.time() )

function distance ( x1, y1, x2, y2 )
 
	return math.sqrt ((( x2 - x1 ) ^ 2 ) + (( y2 - y1 ) ^ 2 ))
end

function wait ( action )
    while action:isBusy () do coroutine:yield () end
end

function crazyFunc ()
    kitteh:moveRot ( 360, 2 )
    wait ( kitteh:moveScl ( 0.5, 0.5, 0.75 ))
    kitteh:moveScl ( -0.5, -0.5, 0.75 )
end

function addCar ()
	
	local row = math.random(4)
	
	local car = MOAIProp2D.new ()
	car:setDeck ( carQuad )
	car:setLoc ( -180, 8 + row * 32 )
	cars [ car ] = car
	
	layer:insertProp ( car )
	
	--
	function car:main ()
		MOAIThread.blockOnAction ( self:seekLoc ( 380, 8 + row * 32, 6 + row*2, MOAIEaseType.LINEAR ))
		layer:removeProp ( car )
		cars [ car ] = nil
	end
	
	car.thread = MOAIThread.new ()
	car.thread:run ( car.main, car )
end

function clickCallback ( down )
	if not kitteh.alive then
		return
	end
		
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
					local t = MOAIThread.new ()
					t:run ( crazyFunc )
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

function threadFunc ()

	addCar ()

	local frame = 0
	local resetCounter = 0
	
	while not gameWon do
		frame = frame + 1
		coroutine.yield ()

		for car in pairs (cars) do
			local x1, y1 = kitteh:getLoc ()
			local x2, y2 = car:getLoc ()
			
			if distance ( x1,y1, x2,y2 ) < 30 and resetCounter < frame then
				resetCounter = frame + 60
				kitteh.alive = false
			end
		end
		
		if (frame % 90 == 0) then
			addCar ()
		end
		
		if resetCounter == frame then
			kitteh:setLoc ( 16, START_Y )
			kitteh.alive = true
		end
	end
end

thread = MOAIThread.new ()
thread:run ( threadFunc )
