-- BIOS-like startup screen with delay
local mon = peripheral.find("monitor") or error("No monitor found")
mon.setTextScale(1)
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.green)

-- get monitor width
local width, height = mon.getSize()

-- Function to clear a specific line on the monitor
local function clearLine(row)
    mon.setCursorPos(1, row)
    mon.write(string.rep(" ", width))
end

-- Function to clear whole monitor
local function fullClear()
    mon.setBackgroundColor(colors.black)
    mon.clear()
end

-- Display startup sequence
local function displayStartup()
    fullClear()

    local messages = {
        "Memory Check . . .",
        "Loading Kernel . . .",
        "Initializing Disk . . ."
    }

    for i, msg in ipairs(messages) do
        clearLine(i)
        mon.setCursorPos(1, i)
        mon.write(msg)
        os.sleep(math.random(1, 5))
    end

    -- Fake animation spinner
    local anim = {"/", "|", "\\"}
    for i, frame in ipairs(anim) do
        clearLine(1)
        mon.setCursorPos(1, 1)
        mon.write(frame)
        os.sleep(math.random(1, 5))
    end

    -- After animation, full clear
    fullClear()

    -- Fancy message to say monitor video output has started
    mon.setCursorPos(1, 1)
    mon.setTextColor(colors.lime)
    mon.write("Starting video output...")
    os.sleep(2)
    fullClear()
end

-- Run the BIOS boot sim
displayStartup()

-- Load and run the main program
local url = "https://raw.githubusercontent.com/kazoothetoot/cc-mining-bot/refs/heads/main/main.lua"
local response = http.get(url)
if response then
    local script = response.readAll()
    response.close()
    local fn = load(script)
    if fn then fn() else print("Script error") end
else
    print("Failed to download the script.")
end
