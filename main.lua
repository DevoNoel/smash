function love.load()
  player = {
    sprites = {
      neutral = love.graphics.newImage('orc.png'),
      walk = love.graphics.newImage('orc2.png'),
      walkAlt = love.graphics.newImage('orc3.png'),
      guns = love.graphics.newImage('orc-guns.png'),
      gunWalk = love.graphics.newImage('orc-guns2.png'),
      gunWalkAlt = love.graphics.newImage('orc-guns3.png'),
    },
    x = 256,
    y = 256,
    speed = 300,
    flipSprite = false,
    unholstered = false,
    moving = false,
    aTimer = 0,
    aRate = 0.3,
    aSwitch = false,
  }
end

function love.draw()
  if player.flipSprite then
    love.graphics.draw(getActiveSprite(), player.x, player.y, 0, -1, 1)
  else
    love.graphics.draw(getActiveSprite(), player.x, player.y, 0, 1, 1)
  end
end

function love.update(dt)
  playerAnimateTimer(dt)
  playerMove(dt)
end

function getActiveSprite()
  if player.unholstered then
    if player.moving then
      return playerAnimationSwitch(player.sprites.gunWalk, player.sprites.gunWalkAlt)
    else
      return player.sprites.guns
    end
  else
    if player.moving then
      return playerAnimationSwitch(player.sprites.walk, player.sprites.walkAlt)
    else
      return player.sprites.neutral
    end
  end
end

function playerMove(dt)
  if love.keyboard.isDown("left") or love.keyboard.isDown("right") or love.keyboard.isDown("up") or love.keyboard.isDown("down") then
    player.moving = true
  else
    player.moving = false
  end


  if love.keyboard.isDown("left") then
    player.flipSprite = true
    player.x = player.x - math.floor(player.speed * dt)
  elseif love.keyboard.isDown("right") then
    player.flipSprite = false
    player.x = player.x + math.floor(player.speed * dt)
  end

  if love.keyboard.isDown("up") then
    player.y = player.y - math.floor(player.speed * dt)
  elseif love.keyboard.isDown("down") then
    player.y = player.y + math.floor(player.speed * dt)
  end
end

function playerAnimateTimer(dt)
  if player.moving then
    player.aTimer = player.aTimer + dt
    if player.aTimer >= player.aRate then
      player.aTimer = 0
      player.aSwitch = not player.aSwitch
    end
  else
    player.aTimer = 0
  end
end

function playerAnimationSwitch(s1, s2)
  if player.aSwitch then
    return s2
  else
    return s1
  end
end

function love.keypressed(key)
  if key == "lshift" or key == "rshift" then
    unholster()
  end
end

function unholster()
  if player.unholstered then
    player.unholstered = false
  else
    player.unholstered = true
  end
end

