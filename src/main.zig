const std = @import("std");
const Image = @import("image.zig").Image;
const Vec3 = @import("vec.zig").Vec3;

const width = 640;
const height = 480;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    const img_buffer = try alloc.alloc(u8, width * height * 3);
    defer alloc.free(img_buffer);
    @memset(img_buffer, 255);
    var frame = Image{
        .buffer = img_buffer,
        .width = width,
        .height = height,
    };

    var write_buffer = std.ArrayList(u8).init(alloc);
    defer write_buffer.deinit();
    try frame.saveAsPPM("img.ppm", alloc);
}
