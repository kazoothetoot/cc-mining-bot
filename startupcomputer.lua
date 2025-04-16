-- setup
local mon = peripheral.find("monitor") or error("No monitor found")
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem))

mon.setTextScale(1)
mon.setBackgroundColor(colors.black)

function drawUI()
    mon.clear()

    mon.setCursorPos(1, 1)
    mon.setBackgroundColor(colors.green)
    mon.setTextColor(colors.white)
    mon.write("Move Forward")

    mon.setCursorPos(1, 2)
    mon.setBackgroundColor(colors.orange)
    mon.setTextColor(colors.white)
    mon.write("Start Mining")

    mon.setCursorPos(1, 3)
    mon.setBackgroundColor(colors.orange)
    mon.setTextColor(colors.yellow)
    mon.write("Fuel Check")

    mon.setCursorPos(1, 4)
    mon.setBackgroundColor(colors.red)
    mon.setTextColor(colors.white)
    mon.write("Exit")
end

local function isInBox(x, y, x1, y1, x2, y2)
    return x >= x1 and x <= x2 and y >= y1 and y <= y2
end

while true do
    drawUI()  -- Redraw UI on each loop to reset the screen.
    local _, _, x, y = os.pullEvent("monitor_touch")

    -- Move Forward button
    if isInBox(x, y, 1, 1, 10, 1) then
        rednet.broadcast("moveforward")
        mon.setCursorPos(1, 6)
        mon.clearLine(6)
        mon.write("Moving Forward...")

    -- Start Mining button
    elseif isInBox(x, y, 1, 2, 12, 2) then
        rednet.broadcast("mine", "turtle")
        mon.setCursorPos(1, 6)
        mon.clearLine(6)
        mon.write("Started Mining...")

    -- Fuel Check button
    elseif isInBox(x, y, 1, 3, 18, 3) then
        rednet.broadcast("fuel", "turtle")
        mon.setCursorPos(1, 6)
        mon.clearLine(6)
        mon.write("Fuel Check Pressed")
        
        -- Wait for the turtle's response
        local id, reply = rednet.receive("computer", 5)  -- Adjust timeout if needed
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
        mon.clearLine(6)
        mon.write("Exiting...")
        os.sleep(1)  -- Give it a moment to broadcast the exit signal
        term.setCursorPos(1, 1)
        term.clear()
        error("Program Exited")  -- Exit the program gracefully
    end
end
