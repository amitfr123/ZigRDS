const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;

pub fn RList(comptime T: type) type {
    return struct {
        const Self = @This();
        const RNode = struct { prev: ?*RNode = null, next: ?*RNode = null, data: T };

        first: ?*RNode = null,
        last: ?*RNode = null,
        len: usize = 0,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Self {
            return Self{ .allocator = allocator };
        }

        pub fn pushBack(self: *Self, data: T) !void {
            var new_node: *RNode = try self.allocator.create(RNode);
            new_node.* = RNode{ .data = data }; // memory is garbanzo after create
            if (self.last != null) {
                self.last.?.next = new_node;
            }
            new_node.prev = self.last;
            self.last = new_node;
            if (self.len == 0) {
                self.first = self.last;
            }
            self.len += 1;
        }

        pub fn pushFront(self: *Self, data: T) !void {
            var new_node: *RNode = try self.allocator.create(RNode);
            new_node.* = RNode{ .data = data }; // memory is garbanzo after create
            if (self.first != null) {
                self.first.?.prev = new_node;
            }
            new_node.next = self.first;
            self.first = new_node;
            if (self.len == 0) {
                self.last = self.first;
            }
            self.len += 1;
        }

        pub fn popFront(self: *Self) void {
            if (self.first == null) {
                return;
            }
            self.len -= 1;
            const temp: *RNode = self.first.?;
            self.first = self.first.?.next;
            if (self.first != null) {
                self.first.?.prev = null;
            }
            self.allocator.destroy(temp);
        }

        pub fn popBack(self: *Self) void {
            if (self.last == null) {
                return;
            }
            self.len -= 1;
            const temp: *RNode = self.last.?;
            self.last = self.last.?.prev;
            if (self.last != null) {
                self.last.?.next = null;
            }
            self.allocator.destroy(temp);
        }

        pub fn front(self: *Self) ?T {
            if (self.first == null) {
                return null;
            }
            return self.first.?.data;
        }

        pub fn back(self: *Self) ?T {
            if (self.last == null) {
                return null;
            }
            return self.last.?.data;
        }

        pub fn clear(self: *Self) void {
            while (self.front() != null) {
                self.popFront();
            }
            self.len = 0;
        }

        pub fn deinit(self: *Self) void {
            clear(self);
        }

        pub fn size(self: *Self) usize {
            return self.len;
        }
    };
}

test "list push front" {
    var temp = RList(u8).init(testing.allocator);
    defer temp.deinit();
    try temp.pushFront(1);
    try testing.expect(temp.front().? == 1 and temp.size() == 1);
    try temp.pushFront(2);
    try testing.expect(temp.front().? == 2 and temp.size() == 2);
    try temp.pushFront(3);
    try testing.expect(temp.front().? == 3 and temp.size() == 3);
    try testing.expect(temp.back().? == 1);
}

test "list push back" {
    var temp = RList(u8).init(testing.allocator);
    defer temp.deinit();
    try temp.pushBack(1);
    try testing.expect(temp.back().? == 1 and temp.size() == 1);
    try temp.pushBack(2);
    try testing.expect(temp.back().? == 2 and temp.size() == 2);
    try temp.pushBack(3);
    try testing.expect(temp.back().? == 3 and temp.size() == 3);
    try testing.expect(temp.front().? == 1);
}

test "list pop front" {
    var temp = RList(u8).init(testing.allocator);
    defer temp.deinit();
    try temp.pushFront(1);
    try temp.pushFront(2);
    try testing.expect(temp.front().? == 2 and temp.size() == 2);
    temp.popFront();
    try testing.expect(temp.front().? == 1 and temp.size() == 1);
}

test "list pop back" {
    var temp = RList(u8).init(testing.allocator);
    defer temp.deinit();
    try temp.pushFront(1);
    try temp.pushFront(2);
    try testing.expect(temp.back().? == 1 and temp.size() == 2);
    temp.popBack();
    try testing.expect(temp.front().? == 2 and temp.size() == 1);
}
