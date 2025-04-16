local mon = peripheral.find("monitor") or error("No monitor found")
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem)) -- Open the modem for rednet communication

mon.setTextScale(1)
mon.setBackgroundColor(colors.black)

-- Function to draw the UI on the monitor
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
end

-- Function to check if the touch was within a specific box area
local function isInBox(x, y, x1, y1, x2, y2)
    -- Ensure x1, y1 is the top-left and x2, y2 is the bottom-right corner
    local left = math.min(x1, x2)
    local right = math.max(x1, x2)
    local top = math.min(y1, y2)
    local bottom = math.max(y1, y2)

    return x >= left and x <= right and y >= top and y <= bottom
end

-- Function to check for messages from the turtle and display them
local function showTurtleMessage()
    local id, message = rednet.receive(5)  -- Wait for a message with a timeout of 5 seconds

    if message then
        -- Output the message with red background and white text
        mon.setCursorPos(1, 9)  -- Set position where the message will appear
        mon.setBackgroundColor(colors.red)
        mon.setTextColor(colors.white)
        mon.write(message)

        -- Wait for 5 seconds
        os.sleep(5)

        -- Clear the line after 5 seconds
        mon.setCursorPos(1, 9)  -- Set cursor to the same position where the message was written
        mon.clearLine()
    end
end

-- Function to detect a right-click on the monitor
local function isRightClick(x, y)
    -- We can't directly distinguish right-clicks in the monitor_touch event, so we check using an event workaround
    local _, _, _, _, button = os.pullEvent("monitor_touch")
    return button == 2  -- 2 represents a right-click
end

-- Main loop to continuously display UI and handle button interactions
while true do
    drawUI()  -- Redraw UI on each loop to reset the screen.
    local _, _, x, y = os.pullEvent("monitor_touch")

    if isRightClick(x, y) then
        -- Right-click behavior for the buttons
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
            local id, reply = rednet.receive(5)
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
            os.sleep(1)
            term.setCursorPos(1, 1)
            term.clear()
            error("Program Exited")  -- Exit the program gracefully
        end
    end

    showTurtleMessage()  -- Display any incoming messages from the turtle
end
