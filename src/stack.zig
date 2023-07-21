const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const List = @import("list.zig").RList;

fn RStack(comptime T: type) type {
    return struct {
        const Self = @This();
        list: List(T),

        pub fn init(allocator: Allocator) Self {
            return Self{ .list = List(T).init(allocator) };
        }

        pub fn push(self: *Self, data: T) !void {
            try self.list.pushFront(data);
        }

        pub fn pop(self: *Self) void {
            self.list.popFront();
        }

        pub fn top(self: *Self) ?T {
            return self.list.front();
        }

        pub fn clear(self: *Self) void {
            self.list.clear();
        }

        pub fn deinit(self: *Self) void {
            clear(self);
        }

        pub fn size(self: *Self) usize {
            return self.list.size();
        }
    };
}
test "stack push and pop" {
    var temp = RStack(u8).init(testing.allocator);
    defer temp.deinit();
    try temp.push(1);
    try testing.expect(temp.top().? == 1 and temp.size() == 1);
    try temp.push(2);
    try testing.expect(temp.top().? == 2 and temp.size() == 2);
    try temp.push(3);
    try testing.expect(temp.top().? == 3 and temp.size() == 3);
    temp.pop();
    try testing.expect(temp.top().? == 2 and temp.size() == 2);
    temp.pop();
    try testing.expect(temp.top().? == 1 and temp.size() == 1);
    temp.pop();
    try testing.expect(temp.top() == null and temp.size() == 0);
    temp.pop();
    try testing.expect(temp.top() == null and temp.size() == 0);
}
