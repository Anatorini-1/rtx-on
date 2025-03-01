const std = @import("std");

const Vec3 = @import("vec.zig").Vec3;
const Point = Vec3;
const Color = Vec3;

const Sphere = @import("shapes.zig").Sphere;
const Shape = @import("shapes.zig").Shape;
const ShapeType = @import("shapes.zig").ShapeType;

const Image = @import("image.zig").Image;
const Ray = @import("ray.zig").Ray;
const util = @import("util.zig");

const Viewport = struct {
    width: f64,
    height: f64,
    u: Vec3,
    v: Vec3,
    pixel_delta_u: Vec3,
    pixel_delta_v: Vec3,
    pixel_00: Vec3,
    pub fn pixel_center(self: Viewport, x: usize, y: usize) Point {
        const _y: f64 = @floatFromInt(y);
        const _x: f64 = @floatFromInt(x);
        const center = self.pixel_00.add(self.pixel_delta_u.mul(_x)).add(self.pixel_delta_v.mul(_y));
        return center;
    }
    pub fn pixel_center_offset(self: Viewport, x: usize, y: usize, offset: Vec3) Point {
        const _y: f64 = @as(f64, @floatFromInt(y)) + offset.y();
        const _x: f64 = @as(f64, @floatFromInt(x)) + offset.x();

        const center = self.pixel_00.add(self.pixel_delta_u.mul(_x)).add(self.pixel_delta_v.mul(_y));
        return center;
    }
};

pub const Camera = struct {
    width: u32,
    height: u32,
    center: Point,
    focal_length: f64,
    viewport: Viewport,
    const max_depth = 10;
    const rays_per_pixel: usize = 10;
    pub const sample_scale_factor: f64 = 1.0 / @as(f64, @floatFromInt(rays_per_pixel));
    pub fn new(
        width: u32,
        height: u32,
        center: Point,
        focal_length: f64,
    ) Camera {
        const vp_height = 2.0;
        const vp_width = 2.0 * (@as(f64, @floatFromInt(width)) / @as(f64, @floatFromInt(height)));
        const u = Vec3.new(vp_width, 0, 0);
        const v = Vec3.new(0, -vp_height, 0);
        const focal_vector = Vec3.new(0, 0, focal_length);
        const viewport = Viewport{
            .width = vp_width,
            .height = vp_height,
            .u = u,
            .v = v,
            .pixel_delta_u = u.div(@floatFromInt(width)),
            .pixel_delta_v = v.div(@floatFromInt(height)),
            .pixel_00 = center.sub(focal_vector).sub(u.div(2.0)).sub(v.div(2.0)),
        };
        return Camera{
            .width = width,
            .height = height,
            .center = center,
            .focal_length = focal_length,
            .viewport = viewport,
        };
    }
    pub fn castRay(self: Camera, x: usize, y: usize) Ray {
        const pixel_center = self.viewport.pixel_center(x, y);
        const ray = Ray{
            .direction = pixel_center.sub(self.center),
            .origin = self.center,
        };
        return ray;
    }

    pub fn castRayAround(self: Camera, x: usize, y: usize) Ray {
        const offset = Vec3.randomSquare();
        const pixel_center = self.viewport.pixel_center_offset(x, y, offset);
        const ray = Ray{
            .direction = pixel_center.sub(self.center),
            .origin = self.center,
        };
        return ray;
    }

    pub fn render(self: Camera, world: []const Shape, buffer: Image) !void {
        for (0..self.height) |y| {
            std.debug.print("Progress: {}/{}\n", .{ y, self.height });
            for (0..self.width) |x| {
                var color = Vec3.new(0, 0, 0);
                for (0..rays_per_pixel) |_| {
                    const ray = self.castRayAround(x, y);
                    color = color.add(ray.trace(world, max_depth));
                }
                try buffer.setPixel(x, y, color.mul(sample_scale_factor));
            }
        }
    }
};
