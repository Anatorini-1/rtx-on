const std = @import("std");
const Vec3 = @import("vec.zig").Vec3;

pub const Image = struct {
    buffer: []u8,
    width: usize,
    height: usize,

    pub fn setPixel(self: Image, x: usize, y: usize, color: Vec3) !void {
        if (x >= self.width) return error.PixelXOutOfBounds;
        if (y >= self.height) return error.PixelYOutOfBounds;
        const offset = 3 * (x + y * self.width);
        const pixelColor = color.toInt();
        self.buffer[offset + 0] = pixelColor[0];
        self.buffer[offset + 1] = pixelColor[1];
        self.buffer[offset + 2] = pixelColor[2];
    }

    pub fn saveAsPPM(self: Image, filename: []const u8, alloc: std.mem.Allocator) !void {
        var buffer = std.ArrayList(u8).init(alloc);
        defer buffer.deinit();
        buffer.clearRetainingCapacity();
        const writer = buffer.writer();
        const file = try std.fs.cwd().createFile(
            filename,
            .{},
        );
        defer file.close();
        try std.fmt.format(writer, "P6\n{} {}\n255\n", .{ self.width, self.height });
        _ = try writer.write(self.buffer);
        _ = try file.writer().write(buffer.items);
    }
};
