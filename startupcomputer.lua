-- BIOS-like startup screen with delay
local mon = peripheral.find("monitor") or error("No monitor found")
mon.setTextScale(1)  -- Set text scale to 1 for readability
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.green)

-- Print BIOS startup sequence
local function displayStartup()
    local messages = {
        "Memory Check . . .",
        "Loading Kernel . . .",
        "Initializing Disk . . ."
    }

    -- Display messages with random delays
    for _, message in ipairs(messages) do
        mon.clear()  -- Clear the screen before printing the message
        mon.setCursorPos(1, 1)
        mon.write(message)
        os.sleep(math.random(1, 5))  -- Random sleep between 1 and 5 seconds
    end

    -- Display '/ | \' sequence for visual effect
    local seq = {"/", "|", "\\"}
    for _, s in ipairs(seq) do
        mon.clear()  -- Clear the screen before printing the next symbol
        mon.setCursorPos(1, 1)
        mon.write(s)
        os.sleep(math.random(1, 5))  -- Random sleep between 1 and 5 seconds
    end

    -- Clear screen after the sequence
    mon.clear()
end

-- Call the function to run the startup
displayStartup()

-- Now, load the main script from GitHub and execute it
local url = "https://raw.githubusercontent.com/kazoothetoot/cc-mining-bot/refs/heads/main/main.lua"
local response = http.get(url)
if response then
    local script = response.readAll()
    load(script)()  -- Execute the downloaded script
else
    print("Failed to download the script.")
end
