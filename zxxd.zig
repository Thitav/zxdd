const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("test.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const buf_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    const line_len = 16;
    const group_len = 2;
    var offset: usize = 0;

    while (true) {
        const nread = try buf_stream.read(&buf);
        if (nread <= 0) {
            break;
        }

        var line_it = std.mem.window(u8, buf[0..nread], line_len, line_len);
        while (line_it.next()) |line| {
            std.debug.print("{x:0>8}: ", .{offset});
            var group_it = std.mem.window(u8, line, group_len, group_len);
            while (group_it.next()) |group| {
                for (group) |byte| {
                    std.debug.print("{x}", .{byte});
                }
                std.debug.print(" ", .{});
            }

            std.debug.print(" ", .{});

            for (0..((line_len - line.len) * 2) + ((line_len - line.len) / group_len)) |_| {
                std.debug.print(" ", .{});
            }

            for (0..line.len) |i| {
                std.debug.print("{c}", .{line[i]});
            }

            std.debug.print("\n", .{});
            offset += line_len;
        }
    }
}
