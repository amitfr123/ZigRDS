const std = @import("std");
const testing = std.testing;

test {
    _ = @import("list.zig");
    _ = @import("stack.zig");
    testing.refAllDecls(@This());
}
