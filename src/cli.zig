const std = @import("std");
const builtin = @import("builtin");
const cova = @import("cova");

// Command imports
const init_cmd = @import("./commands/init.zig");

pub const CommandT = cova.Command.Custom(.{
    .global_help_prefix = "Minecraft Server Management",
});

pub const OptionT = CommandT.OptionT;
pub const ValueT = CommandT.ValueT;

pub const setup_cmd: CommandT = .{
    .name = "mcm-cli",
    .description = "A command line interface for managing a fabric minecraft server",
    .sub_cmds = &.{
        init_cmd.command_struct,
        CommandT{
            .name = "update",
            .description = "Update the server",
        },
    },
};
