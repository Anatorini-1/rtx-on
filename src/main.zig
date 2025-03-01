const std = @import("std");
const Image = @import("image.zig").Image;
const Ray = @import("ray.zig").Ray;

const Vec3 = @import("vec.zig").Vec3;
const Point = Vec3;
const Color = Vec3;

const Sphere = @import("shapes.zig").Sphere;
const Shape = @import("shapes.zig").Shape;
const ShapeType = @import("shapes.zig").ShapeType;

const aspect_ratio = 16.0 / 9.0;

var width: u32 = undefined;
var height: u32 = undefined;

const world = @import("world.zig").World;

const Camera = @import("camera.zig").Camera;

pub fn main() !void {
    width = 640;
    height = @intFromFloat(@as(f64, @floatFromInt(width)) / aspect_ratio);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    const img_buffer = try alloc.alloc(u8, width * height * 3);
    defer alloc.free(img_buffer);
    @memset(img_buffer, 255);

    const camera = Camera.new(
        width,
        height,
        Point.new(0, 0, 0),
        1.0,
    );
    std.debug.print("{}\n", .{Camera.sample_scale_factor});

    var frame = Image{
        .buffer = img_buffer,
        .width = width,
        .height = height,
    };

    try camera.render(&world, frame);

    var write_buffer = std.ArrayList(u8).init(alloc);
    defer write_buffer.deinit();
    try frame.saveAsPPM("img.ppm", alloc);
}

// https://raytracing.github.io/books/RayTracingInOneWeekend.html#rays,asimplecamera,andbackground/sendingraysintothescene
