local modem = peripheral.find("modem")
if modem then
    print("Wireless modem found!")
else
    print("No modem found!")
end