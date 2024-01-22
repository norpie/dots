local rule = {
  matches = {
    {
      { "device.name", "equals", "alsa_output.pci-0000_0d_00.6.analog-surround-51" },
    },
  },
  apply_properties = {
    ["device.nick"] = "Speakers",
    ["device.description"] = "Speakers",
  },
}

table.insert(alsa_monitor.rules,rule)

local rule = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Focusrite_Scarlett_2i2_USB-00.Direct__hw_USB__sink" },
    },
  },
  apply_properties = {
    ["device.nick"] = "Interface",
    ["device.description"] = "Interface",
  },
}

table.insert(alsa_monitor.rules,rule)
