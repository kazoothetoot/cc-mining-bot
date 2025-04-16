-- setup modem
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem))

-- check if the computer is connected to the modem
local function checkConnection()
  if modem then
    rednet.broadcast("Connected", "turtle")
  else
    rednet.broadcast("Not Found!", "turtle")
  end
end

-- check fuel level and send to computer
local function checkFuel()
  local fuelLevel = turtle.getFuelLevel()
  if fuelLevel <= 10 then
    rednet.broadcast("Fuel is low: " .. fuelLevel, "fuel")  -- Notify computer
    return true  -- Indicates fuel is low
  end
  return false  -- Indicates fuel is fine
end

-- check if the turtle's inventory is full
local function checkInventory()
  for i = 1, 16 do  -- Turtle has 16 slots
    if turtle.getItemCount(i) == 0 then
      return false  -- Inventory is not full, we have space
    end
  end
  return true  -- Inventory is full
end

-- move turtle forward by a specific number of blocks
local function moveForward(blocks)
  for i = 1, blocks do
    if turtle.detect() then
      turtle.dig()  -- Mine if something is in the way
    end
    turtle.forward()
  end
end

-- return turtle to starting position (assumes 6 blocks forward from start)
local function returnToStart()
  for i = 1, 6 do  -- Move back 6 blocks to return to the start
    turtle.back()
  end
end

-- start mining a 6x6 area, move down and repeat
local function startMining()
  local width, height = 6, 6
  
  for row = 1, height do
    for col = 1, width do
      if turtle.detect() then
        turtle.dig()  -- Mine if there's a block in the way
      end
      turtle.forward()
    end
    
    -- After finishing a row, adjust the position for the next row
    if row < height then
      turtle.turnRight()  -- Turn to face the next row
      turtle.forward()    -- Move forward to the next row position
      turtle.turnRight()  -- Turn to face the correct direction
      moveForward(width)  -- Move back to the starting position of the new row
      turtle.turnLeft()   -- Turn to face the next row
      turtle.turnLeft()   -- Turn to the correct direction
    end
  end
end

-- main loop
while true do
  -- Listen for the "moveforward" or "mine" signals from the computer
  local id, message = rednet.receive("computer")
  
  if message == "moveforward" then
    -- Check for low fuel level before doing anything
    if checkFuel() then
      break  -- Stop if fuel is low
    end

    -- check if inventory is full, return to start if true
    if checkInventory() then
      rednet.broadcast("Inventory full, returning to start", "turtle")
      returnToStart()
      -- Here you would add logic to unload items from the turtle's inventory
      -- (e.g. drop items, transfer to a chest, etc.)
      break  -- Exit loop to unload, restart mining after unloading
    end

    -- Move the turtle forward 6 blocks to get into position
    moveForward(6)
    
  elseif message == "mine" then
    -- Start mining the 6x6 area when "mine" signal is received
    startMining()

    -- After mining, move down one block and repeat mining
    turtle.down()  -- Move down to the next layer of blocks to mine

    rednet.broadcast("Mining complete", "turtle")  -- Notify the computer that mining is done
  end
end

-- exit condition: turtle returns when done
rednet.broadcast("Turtle has finished mining", "turtle")
