const std = @import("std");
const cli = @import("./cli.zig");

// Command imports
const init_cmd = @import("./commands/init.zig");

pub fn matchCommand(cmd: *const cli.CommandT) !void {
    if (cmd.matchSubCmd("init")) try init_cmd.run(cmd);
}
