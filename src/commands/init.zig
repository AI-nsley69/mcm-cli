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

            var released_versions = std.ArrayList(minecraft.version).init(alloc);
            defer released_versions.deinit();
            for (response.value.versions) |item| {
                if (std.mem.eql(u8, item.type, "release")) {
                    try released_versions.append(item);
                }
            }

            const json_str = try std.json.stringifyAlloc(alloc, released_versions.items[0..5], .{ .whitespace = .indent_2 });
            std.debug.print("Last 5 versions: {s}\n", .{json_str});
        }
    }
}
