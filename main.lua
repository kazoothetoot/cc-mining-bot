-- Connect to monitor and modem
local mon = peripheral.find("monitor") or error("Monitor not found")
local modem = peripheral.find("modem") or error("Modem not found")
rednet.open(peripheral.getName(modem))

mon.setTextScale(1)

-- clear the entire monitor to black
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.white)
mon.clear()

-- function to draw a button
local function drawButton(x, y, label, textColor, bgColor)
    mon.setCursorPos(x, y)
    mon.setTextColor(textColor)
    mon.setBackgroundColor(bgColor)
    mon.write(label)
end

-- draw all buttons
local function drawUI()
    mon.setBackgroundColor(colors.black)
    mon.clear()
    drawButton(2, 2, "[--Start Mining--]", colors.white, colors.green)
    drawButton(2, 4, "[--Ping Test--]", colors.white, colors.green)
    drawButton(2, 6, "[--Exit--]", colors.white, colors.red)
end
print("gay")
drawUI()
