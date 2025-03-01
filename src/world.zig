const Shapes = @import("shapes.zig");
const Vec3 = @import("vec.zig").Vec3;
const Point = @import("vec.zig").Vec3;
const Color = @import("vec.zig").Vec3;

// const s1: Shapes.Shape = .{ .sphere = .{
//     .center = Point.new(0, 0, -1),
//     .radius = 0.25,
//     .color = Color.new(0, 0, 1),
// } };
const s2 = Shapes.Shape{
    .sphere = .{
        .center = Point.new(0, 0, -1),
        .radius = 0.5,
        .color = Color.new(1, 0, 0),
    },
};
const s3 = Shapes.Shape{
    .sphere = .{
        .center = Point.new(0, -100.5, -1),
        .radius = 100,
        .color = Color.new(1, 1, 0),
    },
};

pub const World: [2]Shapes.Shape = [_]Shapes.Shape{ s2, s3 };
