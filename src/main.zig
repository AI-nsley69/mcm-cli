const std = @import("std");
const log = std.log;
const builtin = @import("builtin");
const cova = @import("cova");
const cli = @import("cli.zig");
const matchCommand = @import("commands.zig").matchCommand;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const stdout = std.io.getStdOut().writer();

    const main_cmd = try cli.setup_cmd.init(alloc, .{});
    defer main_cmd.deinit();

    var args_iter = try cova.ArgIteratorGeneric.init(alloc);
    defer args_iter.deinit();

    cova.parseArgs(&args_iter, cli.CommandT, main_cmd, stdout, .{}) catch |err| switch (err) {
        error.UsageHelpCalled,
        error.TooManyValues,
        error.UnrecognizedArgument,
        error.UnexpectedArgument,
        error.CouldNotParseOption,
        error.ExpectedSubCommand,
        => {},
        else => return err,
    };
    if (builtin.mode == .Debug) try cova.utils.displayCmdInfo(cli.CommandT, main_cmd, alloc, &stdout, false);

    try matchCommand(main_cmd, alloc);
}
