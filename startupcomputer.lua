-- startupcomputer.lua

-- Set up the modem and monitor
local mon = peripheral.find("monitor") or error("No monitor found")
local modem = peripheral.find("modem") or error("No modem found")
rednet.open(peripheral.getName(modem))  -- Open the modem for rednet communication

mon.setTextScale(1)
mon.setBackgroundColor(colors.black)
mon.clear()  -- Clear the screen at the beginning to ensure no residual content

-- Function to download and execute the script from GitHub
local function downloadAndRunScript(url)
    print("Downloading script from: " .. url)  -- Debug print for URL
    local response = http.get(url)  -- Get the script from the URL
    if response then
        print("Script downloaded successfully!")  -- Debug print for successful download
        local script = response.readAll()  -- Read all content from the response
        print("Executing downloaded script...")  -- Debug print before execution
        load(script)()  -- Load and execute the script
    else
        print("Failed to download the script.")  -- In case the download fails
    end
end

-- Simulate BIOS startup process (on the monitor)
local function printLoadingText()
    local lines = {
        "Memory Check: 64MB OK...",
        "Loading Kernel...",
        "Initializing Disk Drives...",
        "Checking CPU...",
        "Starting Video Output..."
    }

    for i, line in ipairs(lines) do
        mon.setCursorPos(1, i)  -- Move the cursor to different lines
        mon.setTextColor(colors.white)
        mon.write(line)
        os.sleep(math.random(1, 5))  -- Wait for a random time between 1 and 5 seconds
    end
end

-- Function to simulate memory check with dots appearing one at a time
local function memoryCheck()
    mon.setCursorPos(1, 1)  -- Position for the memory check line
    mon.setTextColor(colors.white)
    mon.write("Memory Check: 64MB")  -- Initial part of the message

    -- Show dots one by one with a random delay
    for i = 1, 3 do
        mon.write(".")
        os.sleep(math.random(1, 3))  -- Random delay for each dot (1 to 3 seconds)
    end

    mon.write(" OK...")  -- Final part of the message
end

-- Function to display random "garbage" characters
local function displayRandomGarbage()
    local chars = {"|", "/", "-", "\\"}
    for i = 1, 20 do
        local randomChar = chars[math.random(1, #chars)]
        mon.setCursorPos(1, i)  -- Move the cursor down to each row
        mon.write(randomChar)
        os.sleep(0.1)  -- Small delay to simulate random characters
    end
end

-- Run BIOS-like start sequence on the monitor
memoryCheck()  -- Call the memory check function

-- Clear the screen after "Starting Video Output" to prepare for next steps
mon.clear()

-- Show the random characters to simulate the "garbage" text
displayRandomGarbage()

-- After "BIOS startup", we proceed with downloading and running the main script
mon.setCursorPos(1, 1)  -- Move the cursor to the top
mon.write("Starting main program...")

-- Pause for a moment
os.sleep(2)

-- Use the provided URL for downloading the Lua script
local githubRawURL = "https://raw.githubusercontent.com/kazoothetoot/cc-mining-bot/refs/heads/main/main.lua"

-- Download and execute the main program from GitHub
downloadAndRunScript(githubRawURL)
