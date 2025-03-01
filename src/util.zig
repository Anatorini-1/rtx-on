const std = @import("std");
const PI = @import("constants.zig").PI;
const INF = @import("constants.zig").INF;

pub fn deg_to_rad(deg: f64) f64 {
    return deg * PI / 180.0;
}

pub const Interval = struct {
    min: f64,
    max: f64,
    pub fn new(min: f64, max: f64) Interval {
        return Interval{ .min = min, .max = max };
    }
    pub fn size(self: Interval) f64 {
        return self.max - self.min;
    }
    pub fn contains(self: Interval, val: f64) bool {
        return val >= self.min and val <= self.max;
    }
    pub fn surrounds(self: Interval, val: f64) bool {
        return val > self.min and val < self.max;
    }
    pub fn clamp(self: Interval, val: f64) f64 {
        if (val < self.min) return self.min;
        if (val > self.max) return self.max;
        return val;
    }

    pub const empty = Interval{ .min = INF, .max = -1 * INF };
    pub const universe = Interval{ .min = -1 * INF, .max = INF };
};

var generator = std.crypto.random;

pub fn randFloat(T: anytype) T {
    return generator.float(T);
}
pub fn randFloatRange(T: anytype, min: T, max: T) T {
    return (min + (max - min) * generator.float(T));
}

pub fn randInt(T: anytype) T {
    return generator.int(T);
}
pub fn randIntRange(T: anytype, min: T, max: T) T {
    return (min + (max - min) * generator.int(T));
}
