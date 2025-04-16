-- Find the modem (to the right of the computer)
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem)) -- Open the modem for rednet communication

-- Find the monitor (on top of the computer)
local mon = peripheral.find("monitor") or error("No monitor found")

-- Set up the monitor properties
mon.setTextScale(1)
mon.setBackgroundColor(colors.black)
mon.clear()

print("Computer is connected to the modem and monitor.")