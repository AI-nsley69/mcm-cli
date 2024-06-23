const std = @import("std");
const cova = @import("cova");
const CommandT = cova.Command.Base();

pub const ProjectStruct = struct {
    pub const SubStruct = struct {
        sub_uint: ?u8 = 5,
        sub_string: []const u8,
    };

    subcmd: SubStruct = .{},
    int: ?i4 = 10,
    flag: ?bool = false,
    strings: [3][]const u8 = .{ "Three", "default", "strings." },
};

const setup_cmd = CommandT.from(ProjectStruct);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const stdout = std.io.getStdOut().writer();

    const main_cmd = try setup_cmd.init(alloc, .{});
    defer main_cmd.deinit();

    var args_iter = try cova.ArgIteratorGeneric.init(alloc);
    defer args_iter.deinit();

    cova.parseArgs(&args_iter, CommandT, &main_cmd, stdout, .{}) catch |err| switch (err) {
        error.UsageHelpCalled => return,
        else => return err,
    };
    try cova.utils.displayCmdInfo(CommandT, &main_cmd, alloc, stdout);
}
