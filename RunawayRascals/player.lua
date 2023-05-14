
anim8=require 'libraries/anim8'
love.graphics.setDefaultFilter("nearest","nearest")

player ={}
player.x=400
player.y=200
player.speed=150

player.spriteSheet=love.graphics.newImage('sprites/Steve.png')
player.grid=anim8.newGrid(64,64,player.spriteSheet:getWidth(),player.spriteSheet:getHeight(),nil,7)

player.animations={}
player.animations.down=anim8.newAnimation(player.grid('1-9',11),0.2)
player.animations.left=anim8.newAnimation(player.grid('1-9',10),0.2)
player.animations.right=anim8.newAnimation(player.grid('1-9',12),0.2)
player.animations.up=anim8.newAnimation(player.grid('1-9',9),0.2)



player.dennisSpriteSheet=love.graphics.newImage('sprites/DennisSprite.png')
player.dennisGrid=anim8.newGrid(64,64,player.dennisSpriteSheet:getWidth(),player.dennisSpriteSheet:getHeight(),nil,7)

player.animations.dennisDown=anim8.newAnimation(player.dennisGrid('1-9',11),0.2)
player.animations.dennisLeft=anim8.newAnimation(player.dennisGrid('1-9',10),0.2)
player.animations.dennisRight=anim8.newAnimation(player.dennisGrid('1-9',12),0.2)
player.animations.dennisUp=anim8.newAnimation(player.dennisGrid('1-9',9),0.2)

player.anim=player.animations.left

function Movement(dt)
    local isMoving=false
    local vx=0
    local vy=0
    if love.keyboard.isDown('right') then
        vx=player.speed
        isMoving=true
        if not petDennisFollowing then
         player.anim=player.animations.right --sets player animation to right
        elseif petDennisFollowing then
            player.anim=player.animations.dennisRight
        end
    end
    
    if love.keyboard.isDown('left')then
        vx=player.speed*-1
        isMoving=true
        if not petDennisFollowing then
        player.anim=player.animations.left --sets player animation to left
        elseif petDennisFollowing then
            player.anim=player.animations.dennisLeft
        end
    end
    if love.keyboard.isDown('up')then
        vy=player.speed*-1
        isMoving=true
        if not petDennisFollowing then
        player.anim=player.animations.up --sets player animation to up
        elseif petDennisFollowing then
            player.anim=player.animations.dennisUp
        end
    end
    if love.keyboard.isDown('down')then
        vy=player.speed
        isMoving=true
        if not petDennisFollowing then
            player.anim=player.animations.down --sets player animation to down
        elseif petDennisFollowing then
            player.anim=player.animations.dennisDown
        end
    end
    if isMoving == false then
        player.anim:gotoFrame(2)
    end
    player.collider:setLinearVelocity(vx, vy)
    player.x=player.collider:getX()
    player.y=player.collider:getY()
end

