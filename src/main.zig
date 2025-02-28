const std = @import("std");
const Image = @import("image.zig").Image;
const Ray = @import("ray.zig").Ray;

const Vec3 = @import("vec.zig").Vec3;
const Point = Vec3;
const Color = Vec3;

const aspect_ratio = 16.0 / 9.0;

var width: u32 = undefined;
var height: u32 = undefined;

const Camera = struct { focal_length: f64, center: Point };

pub fn main() !void {
    width = 640;
    height = @intFromFloat(@as(f64, @floatFromInt(width)) / aspect_ratio);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    const img_buffer = try alloc.alloc(u8, width * height * 3);
    defer alloc.free(img_buffer);
    @memset(img_buffer, 255);

    const viewport_height: f64 = 2.0;
    const viewport_width: f64 = viewport_height * (@as(f64, @floatFromInt(width)) / @as(f64, @floatFromInt(height)));

    const camera = Camera{
        .focal_length = 1.0,
        .center = Point.new(0, 0, 0),
    };
    const focal_vector = Vec3.new(0, 0, camera.focal_length);

    const viewport_u = Vec3.new(viewport_width, 0, 0);
    const viewport_v = Vec3.new(0, -viewport_height, 0);

    const pixel_delta_u = viewport_u.div(@floatFromInt(width));
    const pixel_delta_v = viewport_v.div(@floatFromInt(height));

    const pixel_00 = camera.center.sub(focal_vector).sub(viewport_u.div(2.0)).sub(viewport_v.div(2.0));

    var frame = Image{
        .buffer = img_buffer,
        .width = width,
        .height = height,
    };
    std.debug.print("Pixel 0 0 ", .{});
    pixel_00.print();

    for (0..height) |_y| {
        for (0..width) |_x| {
            const y: f64 = @floatFromInt(_y);
            const x: f64 = @floatFromInt(_x);
            const pixel_center = pixel_00.add(pixel_delta_u.mul(x)).add(pixel_delta_v.mul(y));
            const ray_direction = pixel_center.sub(camera.center);
            const ray = Ray{ .direction = ray_direction, .origin = camera.center };
            const color: Color = ray.color();
            try frame.setPixel(_x, _y, color);
        }
    }

    var write_buffer = std.ArrayList(u8).init(alloc);
    defer write_buffer.deinit();
    try frame.saveAsPPM("img.ppm", alloc);
}

// https://raytracing.github.io/books/RayTracingInOneWeekend.html#rays,asimplecamera,andbackground/sendingraysintothescene
