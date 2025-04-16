local mon = peripheral.find("monitor") or error("No monitor found")
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem)) -- Open the modem for rednet communication

mon.setTextScale(1)
mon.setBackgroundColor(colors.black)

function drawUI()
    mon.clear()  -- Clear the monitor before drawing new UI

    -- Move Forward
    mon.setCursorPos(1, 1)
    mon.setBackgroundColor(colors.green)
    mon.setTextColor(colors.white)
    mon.write("Move Forward")

    -- Start Mining
    mon.setCursorPos(1, 3)  -- Slightly increase the spacing
    mon.setBackgroundColor(colors.orange)
    mon.setTextColor(colors.white)
    mon.write("Start Mining")

    -- Fuel Check
    mon.setCursorPos(1, 5)  -- Increase spacing for better separation
    mon.setBackgroundColor(colors.orange)
    mon.setTextColor(colors.yellow)
    mon.write("Fuel Check")

    -- Exit
    mon.setCursorPos(1, 7)  -- Again, better spacing for clarity
    mon.setBackgroundColor(colors.red)
    mon.setTextColor(colors.white)
    mon.write("Exit")

    -- Test button
    mon.setCursorPos(1, 9)  -- Test button at position (1,9)
    mon.setBackgroundColor(colors.green)
    mon.setTextColor(colors.white)
    mon.write("Test")
end

local function isInBox(x, y, x1, y1, x2, y2)
    -- Ensure x1, y1 is the top-left and x2, y2 is the bottom-right corner
    local left = math.min(x1, x2)
    local right = math.max(x1, x2)
    local top = math.min(y1, y2)
    local bottom = math.max(y1, y2)

    return x >= left and x <= right and y >= top and y <= bottom
end

local function showTurtleMessage()
    local id, message = rednet.receive(5)  -- Wait for a message with a timeout of 5 seconds

    if message then
        -- Output the message with red background and white text
        mon.setCursorPos(1, 11)  -- Set position where the message will appear
        mon.setBackgroundColor(colors.red)
        mon.setTextColor(colors.white)
        mon.write(message)

        -- Wait for 5 seconds
        os.sleep(5)

        -- Clear the line after 5 seconds
        mon.setCursorPos(1, 11)  -- Set cursor to the same position where the message was written
        mon.clearLine()
    end
end

while true do
    drawUI()  -- Redraw UI on each loop to reset the screen.
    local _, _, x, y = os.pullEvent("monitor_touch")

    -- Move Forward button
    if isInBox(x, y, 1, 1, 10, 1) then
        rednet.broadcast("moveforward")
        mon.setCursorPos(1, 6)
        mon.clearLine()  -- Clear the line at 6, no need to pass a number
        mon.write("Moving Forward...")

    -- Start Mining button
    elseif isInBox(x, y, 1, 2, 12, 2) then
        rednet.broadcast("mine", "turtle")
        mon.setCursorPos(1, 6)
        mon.clearLine()
        mon.write("Started Mining...")

    -- Fuel Check button
    elseif isInBox(x, y, 1, 3, 18, 3) then
        rednet.broadcast("fuel", "turtle")
        mon.setCursorPos(1, 6)
        mon.clearLine()
        mon.write("Fuel Check Pressed")
        
        -- Wait for the turtle's response
        local id, reply = rednet.receive(5)  -- No need to specify "computer" channel here
        mon.setCursorPos(1, 7)
        if reply then
            mon.write("Fuel level: " .. reply)
        else
            mon.write("No Response.")
        end

    -- Exit button
    elseif isInBox(x, y, 1, 4, 18, 4) then
        rednet.broadcast("exit", "turtle")
        mon.setCursorPos(1, 6)
        mon.clearLine()
        mon.write("Exiting...")
        os.sleep(1)  -- Give it a moment to broadcast the exit signal
        term.setCursorPos(1, 1)
        term.clear()
        error("Program Exited")  -- Exit the program gracefully

    -- Test button
    elseif isInBox(x, y, 1, 9, 4, 9) then  -- Test button box coordinates (1,9 to 4,9)
        rednet.broadcast("test", "turtle")
        mon.setCursorPos(1, 6)
        mon.clearLine()
        mon.write("Test Button Pressed")
    end
    
    showTurtleMessage()  -- Display any incoming messages from the turtle
end
