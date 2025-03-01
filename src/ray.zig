const std = @import("std");

const Vec3 = @import("vec.zig").Vec3;
const Point = Vec3;
const Color = Vec3;

const Sphere = @import("shapes.zig").Sphere;
const Shape = @import("shapes.zig").Shape;
const ShapeType = @import("shapes.zig").ShapeType;
const Hit = @import("shapes.zig").Hit;

const Interval = @import("util.zig").Interval;

const INF = @import("constants.zig").INF;

pub const Ray = struct {
    origin: Point,
    direction: Vec3,

    pub fn at(self: Ray, t: f64) Point {
        return self.origin.add(self.direction.mul(t));
    }

    pub fn trace(self: Ray, shapes: []const Shape, depth: u32) Color {
        if (depth <= 0) return Vec3.new(0, 0, 0);
        for (shapes) |s| {
            switch (s) {
                .sphere => |sphere| {
                    const _hit = sphere.intersect(
                        self,
                        Interval{ .min = 0, .max = INF },
                    );
                    if (_hit) |hit| {
                        const dir = Vec3.randomOnHemisphere(hit.normal);
                        const diffuse = Ray{ .origin = hit.p, .direction = dir };
                        return diffuse.trace(shapes, depth - 1).mul(0.5);
                        // return Color.new(
                        //     hit.normal.x() + 1,
                        //     hit.normal.y() + 1,
                        //     hit.normal.z() + 1,
                        // ).mul(0.5);
                    }
                },
                .cube => {},
            }
        }

        // No hit => return background gradient

        const dir = self.direction.normlize();
        const a = 0.5 * (dir.y() + 1);
        return Vec3.new(1, 1, 1).mul(1 - a).add(Vec3.new(0.5, 0.7, 1.0).mul(a));
    }
};
