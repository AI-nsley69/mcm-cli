const std = @import("std");
const cova = @import("cova");
const cli = @import("../cli.zig");
const utils = @import("../utils.zig");

const opt_struct = struct {
    should_install: ?bool = false,
};

pub const command_struct = cli.CommandT{
    .name = "init",
    .description = "Initialize a new server",
    .opts = &.{
        cli.OptionT{
            .name = "install",
            .description = "Install fabric, minecraft, etc",
            .short_name = 'i',
            .long_name = "install",
            .val = cli.ValueT.ofType(bool, .{
                .name = "should_install",
                .description = "Whether to install fabric, minecraft, etc",
            }),
        },
    },
};

pub fn run(cmd: *const cli.CommandT) !void {
    std.debug.print("CommandT: {any}", .{cmd});
    // const opts = try cmd.getOpts(.{});
    // const should_install_opt = opts.get("should_install");
    // const should_install = (should_install_opt.?.val.isSet()) orelse false;
    // if (should_install) {
    //     std.debug.print("yippeee, we should install minecraft!", .{});
    // }
}
