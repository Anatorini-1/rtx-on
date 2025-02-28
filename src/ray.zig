const std = @import("std");

const Vec3 = @import("vec.zig").Vec3;
const Point = Vec3;
const Color = Vec3;

const Sphere = @import("shapes.zig").Sphere;

const s1 = Sphere{
    .center = Point.new(0, 0, -1),
    .radius = 0.5,
    .color = Color.new(1, 0, 0),
};
const s2 = Sphere{
    .center = Point.new(-0.5, 0.0, -1),
    .radius = 0.5,
    .color = Color.new(1, 1, 0),
};

const spheres = [_]Sphere{ s1, s2 };

pub const Ray = struct {
    origin: Point,
    direction: Vec3,
    pub fn at(self: Ray, t: f64) Point {
        return self.origin.add(self.direction.mul(t));
    }

    pub fn color(self: Ray) Color {
        for (spheres) |s| {
            const intersect = s.intersect(self);
            if (intersect) |col| {
                return col;
            }
        }
        const dir = self.direction.normlize();
        const a = 0.5 * (dir.y() + 1);
        return Vec3.new(1, 1, 1).mul(1 - a).add(Vec3.new(0.5, 0.7, 1.0).mul(a));
    }
};
