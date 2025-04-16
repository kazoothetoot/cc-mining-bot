local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem)) -- Open the modem for rednet communication

while true do
  local id, message = rednet.receive(5)  -- Wait for the computer's command with a timeout of 5 seconds

  if message == "moveforward" then
    -- Add logic to move the turtle forward
    turtle.forward()
    rednet.broadcast("Turtle moved forward", "computer")

  elseif message == "mine" then
    -- Add logic to start mining
    rednet.broadcast("Mining started", "computer")

  elseif message == "fuel" then
    -- Add logic to check fuel level
    local fuelLevel = turtle.getFuelLevel()
    rednet.broadcast(fuelLevel, "computer")

  elseif message == "exit" then
    -- Exit the program gracefully
    rednet.broadcast("Turtle exiting", "computer")
    break

  elseif message == "test" then
    -- Handle test button press
    rednet.broadcast("Test successful!", "computer")
  end
end
