-- BIOS-like startup screen with delay
local mon = peripheral.find("monitor") or error("No monitor found")
mon.setTextScale(1)  -- Set text scale to 1 for readability
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.green)

-- Function to display the startup sequence
local function displayStartup()
    local messages = {
        "Memory Check . . .",
        "Loading Kernel . . .",
        "Initializing Disk . . ."
    }

    -- Display each message with a delay
    for _, message in ipairs(messages) do
        mon.clearLine(1)  -- Clear the first line of the monitor
        mon.setCursorPos(1, 1)
        mon.write(message)
        os.sleep(math.random(1, 5))  -- Random sleep between 1 and 5 seconds
    end

    -- Display '/ | \' animation
    local seq = {"/", "|", "\\"}
    for _, s in ipairs(seq) do
        mon.clearLine(1)  -- Clear the first line again before printing the next symbol
        mon.setCursorPos(1, 1)
        mon.write(s)
        os.sleep(math.random(1, 5))  -- Random sleep between 1 and 5 seconds
    end

    -- After the animation, clear the line
    mon.clearLine(1)
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
