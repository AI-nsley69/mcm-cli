const std = @import("std");

pub fn does_dir_exist(dir: std.fs.Dir, subpath: []const u8) !bool {
    var opened = dir.openDir(subpath, .{}) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };
    defer opened.close();

    return true;
}

pub fn does_file_exist(dir: std.fs.Dir, subpath: []const u8) !bool {
    var opened = dir.openFile(subpath, .{}) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };
    defer opened.close();

    return true;
}

pub fn isInitialized() !bool {
    const cwd = std.fs.cwd();

    const has_config_dir = try does_dir_exist(cwd, ".mcm");
    if (!has_config_dir) {
        return false;
    }

    var config_dir = try cwd.openDir(".mcm", .{});
    defer config_dir.close();

    const has_config_file = try does_file_exist(config_dir, "meta.json");
    if (!has_config_file) {
        return false;
    }

    return true;
}

pub fn checkRequirements(alloc: std.mem.Allocator) !void {
    const java_args: []const []const u8 = &.{ "java", "--version" };
    var java_child = std.process.Child.init(java_args, alloc);
    const process_term = try java_child.spawnAndWait();
    if (process_term.Exited != 0) {
        std.debug.print(":(\n", .{});
        std.process.exit(1);
    }
}
