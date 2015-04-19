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

  suit1 = {
    sprite = love.graphics.newImage('elf.png'),
    x = 100,
    y = 100,
  }

  suit2 = {
    sprite = love.graphics.newImage('elf2.png'),
    x = 400,
    y = 400,
  }

  bullets = {}
  bulletCount = 0
end

function love.draw()
  love.graphics.setColor(255,255,255)

  love.graphics.draw(suit1.sprite, suit1.x, suit1.y, 0, -1, 1)
  love.graphics.draw(suit2.sprite, suit2.x, suit2.y, 0, 1, 1)

  if player.flipSprite then
    love.graphics.draw(getActiveSprite(), player.x, player.y, 0, -1, 1)
  else
    love.graphics.draw(getActiveSprite(), player.x, player.y, 0, 1, 1)
  end

  for i=1, bulletCount, 1 do
    love.graphics.rectangle("fill",
      bullets[i].x,
      bullets[i].y,
      bullets[i].width,
      bullets[i].height)
  end
end

function love.update(dt)
  playerAnimateTimer(dt)
  playerMove(dt)
  bulletsTravel(dt)
  bulletsCollide(dt)
  bulletsClean(dt)
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

  if key == " " then
    shoot()
  end
end

function unholster()
  if player.unholstered then
    player.unholstered = false
  else
    player.unholstered = true
  end
end

function shoot()
  if player.unholstered then
    bulletCount = bulletCount + 1

    if player.flipSprite then
      xOffset = -34
    else
      xOffset = 34
    end

    bullets[bulletCount] = {
      x = player.x + xOffset,
      y = player.y + 45,
      width = 16,
      height = 8,
      speed = 600,
      reverse = player.flipSprite,
      collision = false,
    }
  else
    player.unholstered = true
  end
end

function bulletsTravel(dt)
  for i=1, bulletCount, 1 do
    if bullets[i].reverse then
      bullets[i].x = bullets[i].x - math.floor(bullets[i].speed * dt)
    else
      bullets[i].x = bullets[i].x + math.floor(bullets[i].speed * dt)
    end
  end
end

function bulletsCollide(dt)
  -- for i=1, bulletCount, 1 do
  --   if bullets[i].x <= suit1.x and bullets[i].x >= suit1.x - 5 then
  --     bullets[i].collision = true
  --   end
  -- end
end

function bulletsClean(dt)
  bulletsKept = 0
  keepBullets = {}

  for i=1, bulletCount, 1 do
    if not bullets[i].collision and bullets[i].x > 0 and bullets[i].x < 1000  then
      bulletsKept = bulletsKept + 1
      keepBullets[bulletsKept] = bullets[i]
    end
  end

  bullets = keepBullets
  bulletCount = bulletsKept
end

