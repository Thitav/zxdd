const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("test.txt", .{});
    defer file.close();

    while (true) {
        const byte = file.reader().readByte() catch {
            break;
        };
        std.debug.print("{x}", .{byte});
    }
}
