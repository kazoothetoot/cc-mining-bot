local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem)) -- Open the modem for rednet communication

while true do
    local id, message = rednet.receive(5)  -- Wait for the computer's command with a timeout of 5 seconds

    if message == "moveforward" then
        -- Move the turtle forward
        if turtle.forward() then
            rednet.broadcast("Turtle moved forward", "computer")
        else
            rednet.broadcast("Failed to move forward", "computer")
        end

    elseif message == "mine" then
        -- Start mining logic
        if turtle.dig() then
            rednet.broadcast("Mining started", "computer")
        else
            rednet.broadcast("Failed to mine", "computer")
        end

    elseif message == "fuel" then
        -- Fuel level check logic
        local fuelLevel = turtle.getFuelLevel()
        rednet.broadcast(fuelLevel, "computer")

    elseif message == "exit" then
        -- Exit the program gracefully
        rednet.broadcast("Turtle exiting", "computer")
        break

    elseif message == "test" then
        -- Test button logic
        rednet.broadcast("Test successful!", "computer")
    else
        -- Handle unknown commands gracefully
        rednet.broadcast("Unknown command received", "computer")
    end
end
