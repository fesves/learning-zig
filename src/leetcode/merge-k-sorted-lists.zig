const std = @import("std");

pub const LinkedList = struct {
    val: i32,
    next: ?*LinkedList,
};

pub const KSortedLists = struct {
    result: ?*LinkedList,
    const Self = @This();

    pub fn init(self: *Self, data: []*LinkedList) *Self {
        const length = data.len;
        if (length < 1) {
            self.result = null;
            return self;
        }

        for (data) |item| {
            self.insert(item);
        }
        return self;
    }

    pub fn printResult(self: *Self) void {
        var current = self.result;
        while (current) |node| {
            if (node.next != null) {
                std.debug.print("{} -> ", .{node.val});
            } else {
                std.debug.print("{} ", .{node.val});
            }
            current = node.next;
        }
    }

    pub fn getResult(self: *Self) ?*LinkedList {
        return self.result;
    }

    fn insert(self: *Self, item: *LinkedList) void {
        // Early return the first list if result is null
        if (self.result == null) {
            self.result = item;
            return;
        }

        var currentInsertion: ?*LinkedList = item;
        var currentResultItem = self.result.?;
        // Given that "lists[i] is sorted in ascending order," we only need to check
        //if the item is greater than the first item in the result during the first iteration.
        if (currentResultItem.*.val > item.*.val) {
            const temp = item.*.next;
            item.*.next = currentResultItem;
            self.result = item;
            currentInsertion = temp;
        }

        while (currentInsertion) |insertion| {
            if (currentResultItem.*.next == null) {
                currentInsertion = insertion.*.next;
                insertion.*.next = null;
                currentResultItem.*.next = insertion;
                currentResultItem = insertion;
                continue;
            }

            const next = currentResultItem.*.next.?;
            if (next.*.val > insertion.*.val) {
                currentInsertion = insertion.*.next;
                insertion.*.next = next;
                currentResultItem.*.next = insertion;
                currentResultItem = insertion;
                continue;
            }

            currentResultItem = next;
        }
    }
};
