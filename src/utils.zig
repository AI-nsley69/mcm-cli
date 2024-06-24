// const std = @import("std");

// pub fn checkForConfig() !void {
//     var path_buf: [1024]u8 = undefined;
//     const config_dir = try std.fs.cwd().realpath(".mcm", &path_buf);
//     const dir_exists = try std.fs.cwd().access(&path_buf, .{});
//     if (@TypeOf(dir_exists) == void) {
//         try std.fs.cwd().makePath(config_dir);
//     }

//     const config_file = try std.fs.cwd().createFile(config_dir ++ "/meta.json", .{});
//     defer config_file.close();

//     var buf: [1024]u8 = undefined;
//     const len = try config_file.read(&buf);
//     if (len == 0) {
//         try config_file.writeAll("{}");
//     }
// }
