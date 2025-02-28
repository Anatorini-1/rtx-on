const std = @import("std");

const Vec3 = @import("vec.zig").Vec3;
const Point = Vec3;
const Color = Vec3;

const Ray = @import("ray.zig").Ray;

pub const ShapeType = enum { sphere, cube };

pub const Shape = union(ShapeType) {
    sphere: Sphere,
    cube: Cube,
};

pub const Sphere = struct {
    center: Point,
    radius: f64,
    color: Color,
    pub fn intersect(self: Sphere, ray: Ray) ?Color {
        const a = ray.direction.dot(ray.direction);
        const b = ray.direction.mul(-2).dot(self.center.sub(ray.origin));
        const c_1 = self.center.sub(ray.origin);
        const c = c_1.dot(c_1) - (self.radius * self.radius);

        const delta = b * b - 4 * a * c;
        if (delta < 0) {
            return null;
            // return [2]Point{ null, null };
        } else if (delta == 0) {
            return self.color;
            // return [2]Point{ (-1 * b) / (2 * a), null };
        } else {
            return self.color;
            // const delta_sqrt = std.math.sqrt(delta);
            // return [2]Point{
            //     (-1 * b - delta_sqrt) / (2 * a),
            //     (-1 * b + delta_sqrt) / (2 * a),
            // };
        }
    }
};

pub const Cube = struct {};
