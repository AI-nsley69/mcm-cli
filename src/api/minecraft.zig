const std = @import("std");
const http = std.http;

pub const versionResponse = struct {
    latest: struct {
        release: []u8,
        snapshot: []u8,
    },

    versions: []struct {
        id: []u8,
        type: []u8,
        url: []u8,
        time: []u8,
        releaseTime: []u8,
        sha1: []u8,
        complianceLevel: u8,
    },
};

pub fn getVersions(alloc: std.mem.Allocator) !std.json.Parsed(versionResponse) {
    var client = http.Client{ .allocator = alloc };
    defer client.deinit();

    const uri = try std.Uri.parse("https://piston-meta.mojang.com/mc/game/version_manifest_v2.json");

    var buf: [1024]u8 = undefined;
    var req = try client.open(.GET, uri, .{ .server_header_buffer = &buf });
    defer req.deinit();

    try req.send();
    try req.finish();
    try req.wait();

    try std.testing.expect(req.response.status == .ok);

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(alloc, 1024 * 1024 * 32);
    defer alloc.free(body);

    const json = try std.json.parseFromSlice(versionResponse, alloc, body, .{});
    return json;
}
