const std = @import("std");

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
            @intFromFloat(self.n[0] * 255.999),
            @intFromFloat(self.n[1] * 255.999),
            @intFromFloat(self.n[2] * 255.999),
        };
    }

    pub fn print(self: Vec3) void {
        std.debug.print("[ {d:.1}, {d:.1}, {d:.1} ]\n", .{ self.n[0], self.n[1], self.n[2] });
    }
};
