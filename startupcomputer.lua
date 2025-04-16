-- main.lua

-- Set up the modem and monitor
local mon = peripheral.find("monitor") or error("No monitor found")
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem))  -- Open the modem for rednet communication

mon.setTextScale(1)
mon.setBackgroundColor(colors.black)
mon.clear()

-- Function to download and execute the script from GitHub
local function downloadAndRunScript(url)
    -- Download the raw content from GitHub
    local response = http.get(url)
    
    if not response then
        error("Failed to download the script from GitHub.")
    end

    -- Read the content from the response
    local script = response.readAll()
    
    -- Close the HTTP connection
    response.close()

    -- Load the Lua script as a function and run it
    local func, err = load(script)
    if not func then
        error("Failed to load the script: " .. err)
    end

    -- Run the script
    func()
end

-- Simulate BIOS startup process (optional)
local function printLoadingText()
    local lines = {
        "Memory Check: 64MB OK...",
        "Loading Kernel...",
        "Initializing Disk Drives...",
        "Checking CPU...",
        "Starting Video Output...",
        "Press any key to continue..."
    }

    for _, line in ipairs(lines) do
        print(line)
        os.sleep(1)
    end
end

local function displayRandomGarbage()
    local chars = {"|", "/", "-", "\\"}
    for i = 1, 20 do
        local randomChar = chars[math.random(1, #chars)]
        term.setCursorPos(1, i)
        term.write(randomChar)
        os.sleep(0.1)
    end
end

-- Run BIOS-like start sequence
printLoadingText()
displayRandomGarbage()

-- After "BIOS startup", we proceed with downloading and running the main script
print("Starting main program...")
os.sleep(2)

-- Replace this URL with the raw URL of your GitHub Lua file
local githubRawURL = "https://raw.githubusercontent.com/kazoothetoot/cc-mining-bot/refs/heads/main/main.lua"

-- Download and execute the main program from GitHub
downloadAndRunScript(githubRawURL)
