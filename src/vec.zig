const std = @import("std");
const util = @import("util.zig");

pub const Vec3 = struct {
    n: [3]f64,

    pub fn x(self: Vec3) f64 {
        return self.n[0];
    }
    pub fn y(self: Vec3) f64 {
        return self.n[1];
    }
    pub fn z(self: Vec3) f64 {
        return self.n[2];
    }

    pub fn random() Vec3 {
        return Vec3.new(
            util.randFloat(f64),
            util.randFloat(f64),
            util.randFloat(f64),
        );
    }

    pub fn randomSquare() Vec3 {
        return Vec3.new(
            util.randFloatRange(f64, -0.5, 0.5),
            util.randFloatRange(f64, -0.5, 0.5),
            0,
        );
    }

    pub fn randomIn(min: f64, max: f64) Vec3 {
        return Vec3.new(
            util.randFloatRange(f64, min, max),
            util.randFloatRange(f64, min, max),
            util.randFloatRange(f64, min, max),
        );
    }

    pub fn randomUnitVec() Vec3 {
        var point: Vec3 = undefined;
        var length: f64 = undefined;
        const epsilon: comptime_float = 1e-160;
        while (true) {
            point = Vec3.random();
            length = point.len_squared();
            if (epsilon < length and length <= 1) return point.div(length);
        }
    }

    pub fn randomOnHemisphere(normal: Vec3) Vec3 {
        const vec_on_unit_sphere = Vec3.randomUnitVec();
        if (vec_on_unit_sphere.dot(normal) > 0.0) { //same hemoshpere as normal
            return vec_on_unit_sphere;
        }
        return vec_on_unit_sphere.inverted();
    }
    pub fn new(n1: f64, n2: f64, n3: f64) Vec3 {
        return Vec3{ .n = [3]f64{ n1, n2, n3 } };
    }
    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3.new(
            self.n[0] + other.n[0],
            self.n[1] + other.n[1],
            self.n[2] + other.n[2],
        );
    }
    pub fn inverted(self: Vec3) Vec3 {
        return self.mul(-1);
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        return Vec3.new(
            self.n[0] - other.n[0],
            self.n[1] - other.n[1],
            self.n[2] - other.n[2],
        );
    }

    pub fn mul(self: Vec3, scale: f64) Vec3 {
        return Vec3.new(
            self.n[0] * scale,
            self.n[1] * scale,
            self.n[2] * scale,
        );
    }
    pub fn div(self: Vec3, divisor: f64) Vec3 {
        return Vec3.new(
            self.n[0] / divisor,
            self.n[1] / divisor,
            self.n[2] / divisor,
        );
    }

    pub fn dot(self: Vec3, other: Vec3) f64 {
        return self.n[0] * other.n[0] + self.n[1] * other.n[1] + self.n[2] * other.n[2];
    }
    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return Vec3.new(
            self.n[1] * other.n[2] - self.n[2] * other.n[1],
            self.n[2] * other.n[0] - self.n[0] * other.n[2],
            self.n[0] * other.n[1] - self.n[1] * other.n[0],
        );
    }

    pub fn normlize(self: Vec3) Vec3 {
        return self.div(self.len());
    }

    pub fn len_squared(self: Vec3) f64 {
        return (self.n[0] * self.n[0] + self.n[1] * self.n[1] + self.n[2] * self.n[2]);
    }
    pub fn len(self: Vec3) f64 {
        return std.math.sqrt(self.n[0] * self.n[0] + self.n[1] * self.n[1] + self.n[2] * self.n[2]);
    }
    const intensity = util.Interval.new(0, 0.99999);
    pub fn abs(self: Vec3) Vec3 {
        var rval = Vec3.new(
            self.n[0],
            self.n[1],
            self.n[2],
        );
        for (0..3) |i| {
            if (rval.n[i] < 0) rval.n[i] *= -1;
        }
        return rval;
    }

    pub fn toInt(self: Vec3) [3]u8 {
        return [3]u8{
            @intFromFloat(intensity.clamp(self.n[0]) * 255.999),
            @intFromFloat(intensity.clamp(self.n[1]) * 255.999),
            @intFromFloat(intensity.clamp(self.n[2]) * 255.999),
        };
    }

    pub fn print(self: Vec3) void {
        std.debug.print("[ {d:.1}, {d:.1}, {d:.1} ]\n", .{ self.n[0], self.n[1], self.n[2] });
    }
};
