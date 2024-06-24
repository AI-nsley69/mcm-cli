const std = @import("std");
const cova = @import("cova");
const cli = @import("../cli.zig");
const utils = @import("../utils.zig");

const minecraft = @import("../api/minecraft.zig");

// Imported in the cli file
pub const command_struct = cli.CommandT{
    .name = "init",
    .description = "Initialize a new server",
    .opts = &.{
        cli.OptionT{
            .name = "should_install",
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

pub fn run(cmd: *const cli.CommandT, alloc: std.mem.Allocator) !void {
    const opts = try cmd.getOpts(.{});
    if (opts.get("should_install")) |should_install_opt| {
        if (should_install_opt.val.isSet()) {
            const response = try minecraft.getVersions(alloc);
            defer response.deinit();

            std.debug.print("Latest version: {s}\n", .{response.value.latest.release});
        }
    }
}
