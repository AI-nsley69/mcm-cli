const std = @import("std");
const builtin = @import("builtin");
const cova = @import("cova");

pub const CommandT = cova.Command.Custom(.{
    .global_help_prefix = "Minecraft Server Management",
});

pub const OptionT = CommandT.OptionT;
pub const ValueT = CommandT.ValueT;

pub const setup_cmd: CommandT = .{ .name = "mcm-cli", .description = "A command line interface for managing a fabric minecraft server", .sub_cmds = &.{ CommandT{ .name = "init", .description = "Initialize a new server", .opts = &.{
    OptionT{
        .name = "install",
        .description = "Install fabric, minecraft, etc",
        .short_name = 'i',
        .long_name = "install",
        .val = ValueT.ofType(bool, .{
            .name = "should_install",
            .description = "Whether to install fabric, minecraft, etc",
        }),
    },
} }, CommandT{
    .name = "update",
    .description = "Update the server",
} } };
