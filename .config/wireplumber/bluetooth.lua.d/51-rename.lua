rule = {
  matches = {
    {
      { "node.name", "equals", "bluez_sink.38_18_4C_06_79_A9.a2dp_sink" },
    },
  },
  apply_properties = {
    ["node.nick"] = "Headphones",
    ["node.description"] = "Headphones",
  },
}

table.insert(bluez_monitor.rules,rule)
