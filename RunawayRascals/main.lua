love.math.setRandomSeed(os.time())
function love.load()
    sti=require 'libraries/sti'
    anim8=require 'libraries/anim8'
    camera=require 'libraries/camera'
    wf=require 'libraries/windfield'
    require "player"
    require "timer"
    require "cutscene"
    
    world=wf.newWorld(0,0)

    love.graphics.setDefaultFilter("nearest","nearest")

    gameMap=sti('maps/tileMap.lua')
    cam=camera()

    player.collider=world:newBSGRectangleCollider(400,250,40,60,10)
    player.collider:setFixedRotation(true)

    cam:zoom(1.5)

    walls={}
    if gameMap.layers["Walls"]then
        for i, obj in pairs(gameMap.layers["Walls"].objects)do
            local wall = world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
             wall:setType('static')
             table.insert(walls, wall)
        end     
    end
    dennisMusic=love.audio.newSource("/sounds/digital love.wav","stream")
    music = love.audio.newSource("/sounds/chiptune grooving.wav", "stream")
    music:setVolume(0.2)
    music:play()
    plop=love.audio.newSource("/sounds/Plop.wav", "static")
    runAmok=love.audio.newSource("/sounds/Run-Amok.wav","static")
    
    pet1Found=love.graphics.newImage("sprites/Found Hippy.png")
    pet2Found=love.graphics.newImage("sprites/Found Skullwing.png")
    pet3Found=love.graphics.newImage("sprites/Found MurderFox.png")

    pet1 = love.graphics.newImage("sprites/Hippy.png")
    pet2 = love.graphics.newImage("sprites/Skullwing.png")
    pet3 = love.graphics.newImage("sprites/murder fox.png")
    petDennis=love.graphics.newImage("sprites/Dennis.png")
    petEgg=love.graphics.newImage("sprites/Egg.png")
    
  
    pet1Icon = love.graphics.newImage("sprites/Hippy.png")
    pet2Icon = love.graphics.newImage("sprites/Skullwing.png")
    pet3Icon = love.graphics.newImage("sprites/murder fox.png")

    
    gameStarted=false
    gameOver=false
    gameWin=false

    pet1Following=false
    pet2Following=false
    pet3Following=false
    petDennisFollowing=false
    petEggFollowing=false 
    
    pet1Range=false
    pet2Range=false
    pet3Range=false
    petDennisRange=false
    petEggRange=false

    pet1X,pet1Y=400,200
    pet2X,pet2Y=500,200
    pet3X,pet3Y=600,200
    petDennisX,petDennisY=100,100
    petEggX,petEggY=105,105

    pet1Locations = {
        --{ x = 500, y = 500},
        --{ x = 550, y = 657 },
        { x = 500, y = 1240 }
    }
    pet2Locations = {
        --{ x = 700, y = 500 },
        --{ x = 800, y = 500 },
        { x = 1450, y = 1500 }
    }
    pet3Locations = {
        { x = 1000, y = 400 },
        { x = 1100, y = 400 },
        { x = 1200, y = 400 }
    }
    petDennisLocations = {
        --{ x = 1000, y = 400 },
        --{ x = 1100, y = 400 },
        { x = 150, y = 1750 }
    }
    petEggLocations={
         --{ x = 1000, y = 400 },
        --{ x = 1100, y = 400 },
        { x = 150, y = 150 }
    }

    pet1Index = math.random(1, #pet1Locations)
    pet2Index = math.random(1, #pet2Locations)
    pet3Index = math.random(1, #pet3Locations)
    petDennisIndex= math.random(1, #petDennisLocations)
    petEggIndex=math.random(1,#petEggLocations)

    pet1X, pet1Y = pet1Locations[pet1Index].x, pet1Locations[pet1Index].y
    pet2X, pet2Y = pet2Locations[pet2Index].x, pet2Locations[pet2Index].y
    pet3X, pet3Y = pet3Locations[pet3Index].x, pet3Locations[pet3Index].y
    petDennisX,petDennisY=petDennisLocations[petDennisIndex].x,petDennisLocations[petDennisIndex].y
    petEggX,petEggY= petEggLocations[petEggIndex].x,petEggLocations[petEggIndex].y
end

function love.update(dt)
  
    if not gameOver and not gameWin then   
        Movement(dt)
        player.anim:update(dt)

        cam:lookAt(player.x,player.y)

        local w=love.graphics.getWidth()
        local h=love.graphics.getHeight()

        if cam.x<w/2 then
        cam.x=w/2
        end
        if cam.y<h/2 then
        cam.y=h/2
        end
    
        local mapW=gameMap.width * gameMap.tilewidth
        local mapH=gameMap.height * gameMap.tileheight

        if cam.x > (mapW-w/2) then
            cam.x = (mapW-w/2)
        end
        if cam.y>(mapH-h/2) then
            cam.y=(mapH-h/2)
        end
        world:update(dt)

        TimerUpdate(dt)
        
         -- Update pet positions
         pet1X, pet1Y = pet1Locations[pet1Index].x, pet1Locations[pet1Index].y
         pet2X, pet2Y = pet2Locations[pet2Index].x, pet2Locations[pet2Index].y
         pet3X, pet3Y = pet3Locations[pet3Index].x, pet3Locations[pet3Index].y
         petDennisX,petDennisY=petDennisLocations[petDennisIndex].x,petDennisLocations[petDennisIndex].y
        
        
        if distance(player.x, player.y, pet1X, pet1Y) < 50 then
            pet1Range=true
            if love.keyboard.isDown('e') then
                pet1Following = true
                plop:play()
            end
        end
        if  distance(player.x, player.y, pet1X, pet1Y) > 50 then
            pet1Range=false
        end
        
    
        -- check if player is close to pet2
        if distance(player.x, player.y, pet2X, pet2Y) < 50 then
            pet2Range=true
            if love.keyboard.isDown('e') then
                pet2Following = true
                plop:play()
            end
        end
        if distance(player.x, player.y, pet2X, pet2Y) > 50 then
            pet2Range=false
        end
    
        -- check if player is close to pet3
        if distance(player.x, player.y, pet3X, pet3Y) < 50 then
            pet3Range=true
            if love.keyboard.isDown('e') then
                pet3Following = true
                plop:play()
            end
        end    
        if distance(player.x, player.y, pet3X, pet3Y) > 50 then
            pet3Range=false
        end
 
        -- check if player is close to petDennis
    if distance(player.x, player.y, petDennisX, petDennisY) < 50 then
        petDennisRange=true
        if love.keyboard.isDown('e') then
            petDennisFollowing = true
            plop:play()
            music:stop()
            music=dennisMusic
            music:play()
        end
    end    
    if distance(player.x, player.y, petDennisX, petDennisY) > 50 then
        petDennisRange=false
    end
       
    -- check if player is close to petEgg
        if distance(player.x, player.y, petEggX, petEggY) < 50 then
            petEggRange=true
            if love.keyboard.isDown('e') then
                petEggFollowing = true
                plop:play()
                music:stop()
                music=runAmok
                music:play()
                player.speed=400
            end
        end    
        if distance(player.x, player.y, petEggX, petEggY) > 50 then
            petEggRange=false
        end
else
        if love.keyboard.isDown('escape') then
            love.event.quit()
        end
    end
   
    if not pet1Following then
        pet1Icon = pet1Icon
    elseif pet1Following then
        pet1Icon=pet1Found
        end
        
    if not pet2Following then
        pet2Icon = pet2Icon
    elseif pet2Following then
        pet2Icon=pet2Found
     end

    if not pet3Following then
        pet3Icon=pet3Icon
    elseif pet3Following then
        pet3Icon=pet3Found
    end

    if not petDennisFollowing then
        player.spriteSheet=player.spriteSheet
    elseif petDennisFollowing then
        player.spriteSheet=player.dennisSpriteSheet
    end


    CheckWin()
    
        
end

function love.draw()
  
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Background"])
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        
        player.anim:draw(player.spriteSheet,player.x,player.y,nil,1,nil,32,32)
       
        gameMap:drawLayer(gameMap.layers["Trees"])
        --world:draw()
       
        cutscene = true
       
        
        
    if pet1Following then
        love.graphics.draw(pet1, player.x + 30, player.y - 20, nil, 1.5, 1.5)
        pet1X, pet1Y = player.x + 30, player.y - 20
    else
        love.graphics.draw(pet1, pet1X, pet1Y, nil, 1.5, 1.5)
    end

    -- draw pet2 following the player
    if pet2Following then
        love.graphics.draw(pet2, player.x + 50, player.y - 20, nil, 1.5, 1.5)
        pet2X, pet2Y = player.x + 50, player.y - 20
    else
        love.graphics.draw(pet2, pet2X, pet2Y, nil, 1.5, 1.5)
    end

    -- draw pet3 following the player
    if pet3Following then
        love.graphics.draw(pet3, player.x + 70, player.y - 20, nil, 1.5, 1.5)
        pet3X, pet3Y = player.x + 70, player.y - 20
    else
        love.graphics.draw(pet3, pet3X, pet3Y, nil, 1.5, 1.5)
    end

    if petDennisFollowing then
        love.graphics.draw(petDennis, player.x -75, player.y - 20, nil, 0.5, 0.5)
        petDennisX, petDennisY = player.x + 90, player.y - 20
    else
        love.graphics.draw(petDennis, petDennisX, petDennisY, nil, 0.5, 0.5)
    end
    
    if petEggFollowing then
        love.graphics.draw(petEgg, player.x -100, player.y - 20, nil, 0.5, 0.5)
        petEggX, petEggY = player.x + 90, player.y - 20
    else
        love.graphics.draw(petEgg, petEggX, petEggY, nil, 0.5, 0.5)
    end
    cam:detach()
  
    if gameOver then
        love.graphics.print("You Lose!", love.graphics.getWidth()/2 - 80, love.graphics.getHeight()/2 - 16)
        love.graphics.print("Press Escape to Quit", love.graphics.getWidth()/2 - 120, love.graphics.getHeight()/2 + 32)
  
    else if gameWin then
        love.graphics.print("You Win!", love.graphics.getWidth()/2 - 80, love.graphics.getHeight()/2 - 16)
        love.graphics.print("Press Escape to Quit", love.graphics.getWidth()/2 - 120, love.graphics.getHeight()/2 + 32)
    end
    
    
    TimerDraw()
    cutsceneDraw()
    love.graphics.draw(pet1Icon,500,500,30,30)
    

    if pet1Range or pet2Range or pet3Range or petDennisRange or petEggRange then
        love.graphics.print("Press E to capture a pet", 10, 30)
  end
  local iconSize = 32
    love.graphics.draw(pet1Icon, love.graphics.getWidth() - iconSize-250, love.graphics.getHeight() - iconSize-30, 0, 1.5, 1.5, 0, 0)
    love.graphics.draw(pet2Icon, love.graphics.getWidth() - iconSize-175, love.graphics.getHeight() - iconSize-10, 0, 1.5, 1.5, 0, 0)
    love.graphics.draw(pet3Icon, love.graphics.getWidth() - iconSize-100, love.graphics.getHeight() - iconSize-30, 0, 1.5, 1.5, 0, 0)
end 
end


function distance(x1,y1,x2,y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function CheckWin()
    if pet1Following and pet2Following and pet3Following then
        gameWin=true
    end
end

