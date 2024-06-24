const std = @import("std");
const cli = @import("./cli.zig");

// Command imports
const init_cmd = @import("./commands/init.zig");

pub fn matchCommand(cmd: *const cli.CommandT, alloc: std.mem.Allocator) !void {
    if (cmd.matchSubCmd("init")) |new_cmd| try init_cmd.run(new_cmd, alloc);
}
