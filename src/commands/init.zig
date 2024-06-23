const std = @import("std");
const commands = @import("../cli.zig");

pub const cmd_name: []const u8 = "init";

pub fn run(main_cmd: *const commands.CommandT) !void {
    if (main_cmd.matchSubCmd(cmd_name)) |sub_cmd| {
        std.debug.print("Running init command\n", .{});
        const options = try sub_cmd.getOpts(.{});
        const should_install = options.get("install").?.val.isSet();
        if (should_install) {
            std.debug.print("Install: {}\n", .{should_install});
        }
    }
}
