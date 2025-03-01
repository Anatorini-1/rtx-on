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

const Interval = @import("util.zig").Interval;

pub const Hit = struct { t: f64, p: Point, normal: Vec3, front_face: bool };

pub const Sphere = struct {
    center: Point,
    radius: f64,
    color: Color,
    pub fn intersect(self: Sphere, ray: Ray, interval: Interval) ?Hit {
        const oc = self.center.sub(ray.origin);
        const a = ray.direction.len_squared();
        const h = ray.direction.dot(oc);
        const c = oc.len_squared() - self.radius * self.radius;

        const delta = h * h - a * c;
        if (delta < 0) {
            return null;
        } else {
            const delta_sqrt = std.math.sqrt(delta);
            const t1 = (h - delta_sqrt) / a;
            const t2 = (h + delta_sqrt) / a;
            if (interval.contains(t1)) {
                const p = ray.at(t1);
                const normal_vec = p.sub(self.center).normlize();
                const front_face = ray.direction.dot(normal_vec) < 0;
                return Hit{
                    .t = t1,
                    .p = p,
                    .normal = if (front_face) normal_vec else normal_vec.mul(-1),
                    .front_face = front_face,
                };
            }
            if (interval.contains(t2)) {
                const p = ray.at(t2);
                const normal_vec = p.sub(self.center).normlize();
                const front_face = ray.direction.dot(normal_vec) < 0;
                return Hit{
                    .t = t2,
                    .p = p,
                    .normal = if (front_face) normal_vec else normal_vec.mul(-1),
                    .front_face = front_face,
                };
            }

            return null;
        }
    }
    pub fn normal(self: Sphere, at: Point) Vec3 {
        return at.sub(self.center).normlize();
    }
};

pub const Cube = struct {};
