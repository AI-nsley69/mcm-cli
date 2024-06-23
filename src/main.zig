const std = @import("std");
const builtin = @import("builtin");
const cova = @import("cova");
const commands = @import("cli.zig");
const init = @import("commands/init.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const stdout = std.io.getStdOut().writer();

    const main_cmd = try commands.setup_cmd.init(alloc, .{});
    defer main_cmd.deinit();

    var args_iter = try cova.ArgIteratorGeneric.init(alloc);
    defer args_iter.deinit();

    cova.parseArgs(&args_iter, commands.CommandT, main_cmd, stdout, .{}) catch |err| switch (err) {
        error.UsageHelpCalled,
        // Other common errors can also be handled in the same way. The errors below will call the
        // Command's Usage or Help prompt automatically when triggered.
        error.TooManyValues,
        error.UnrecognizedArgument,
        error.UnexpectedArgument,
        error.CouldNotParseOption,
        error.ExpectedSubCommand,
        => {},
        else => return err,
    };
    if (builtin.mode == .Debug) try cova.utils.displayCmdInfo(commands.CommandT, main_cmd, alloc, &stdout, false);

    try init.run(main_cmd);
}
