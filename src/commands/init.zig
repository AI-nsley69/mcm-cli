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
        cli.OptionT{
            .name = "version",
            .description = "Target version to install",
            .short_name = 'v',
            .long_name = "version",
            .val = cli.ValueT.ofType([]const u8, .{
                .name = "version",
                .description = "Target version to install",
            }),
        },
    },
};

const options = struct {
    version: []const u8,
    should_install: bool,
};

fn parseOptions(cmd: *const cli.CommandT) !options {
    var should_install: bool = false;
    var version: []const u8 = "latest";

    const opts = try cmd.getOpts(.{});

    if (opts.get("should_install")) |should_install_opt| {
        if (should_install_opt.val.isSet()) {
            should_install = try should_install_opt.val.getAs(bool);
        }
    }

    if (opts.get("version")) |version_opt| {
        if (version_opt.val.isSet()) {
            version = try version_opt.val.getAs([]const u8);
        }
    }

    return options{
        .version = version,
        .should_install = should_install,
    };
}

fn filterForRelease(alloc: std.mem.Allocator, versions: std.ArrayList) ![]minecraft.version {
    const list = std.ArrayList(minecraft.version).init(alloc);
    defer list.deinit();

    for (versions) |version| {
        if (std.mem.eql(u8, version.type, "release")) {
            try list.append(version);
        }
    }

    return list.toOwnedSlice();
}

pub fn run(cmd: *const cli.CommandT, alloc: std.mem.Allocator) !void {
    const writer = std.io.getStdOut().writer();
    const is_initialized = try utils.isInitialized();
    if (is_initialized) {
        try writer.writeAll("This server has already been initialized.. Doing nothing\n");
        std.process.exit(0);
    }

    try utils.checkRequirements(alloc);

    const opts = try parseOptions(cmd);
    if (opts.should_install) {
        const response = try minecraft.getVersions(alloc);
        defer response.deinit();

        const version_requested = if (std.mem.eql(u8, opts.version, "latest")) response.value.latest.release else opts.version;

        std.debug.print("Version: {s}\n", .{version_requested});

        const target_version = for (response.value.versions) |version| {
            // Only check against releases
            if (std.mem.eql(u8, version.type, "snapshot")) continue;

            if (std.mem.startsWith(u8, version.id, version_requested)) break version.id;
        } else version_requested;

        std.debug.print("Target version: {s}\n", .{target_version});
    }
}
