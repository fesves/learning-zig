const std = @import("std");
const ArrayList = std.ArrayList;
const AllocationError = error{AllocationError};
const allocator = std.heap.page_allocator;

pub const LinkedList = struct {
    val: i32,
    next: ?*LinkedList,
};

pub const Solver = struct {
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

// k == lists.length
// 0 <= k <= 10^4
// 0 <= lists[i].length <= 500 --------> lists[i] is the linked list itself and should not have more than 500 items
// -10^4 <= lists[i][j] <= 10^4 ------> lists[i][j] is LinkedList.val
// lists[i] is sorted in ascending order.
// The sum of lists[i].length will not exceed 104.
pub const Runner = struct {
    testData: ?*ArrayList(*LinkedList),
    const Self = @This();

    pub fn init(self: *Self) !*Self {
        var lists = ArrayList(*LinkedList).init(allocator);
        self.testData = &lists;
        const rand = std.crypto.random;
        const k = rand.intRangeAtMost(u32, 0, 10000);

        for (0..k) |_| {
            var minVal: i32 = -10000;
            var lastNode: ?*LinkedList = null;
            const linkedListLength = rand.intRangeAtMost(u32, 0, 500);
            for (0..linkedListLength) |linkedListIndex| {
                var node = LinkedList{ .val = 0, .next = null };
                if (lastNode) |last| {
                    minVal = last.*.val;
                    last.*.next = &node;
                } else if (self.testData) |data| if (linkedListIndex == 0) {
                    try data.*.append(&node);
                };

                node.val = rand.intRangeAtMost(i32, minVal, 10000);
                lastNode = &node;
            }
        }

        return self;
    }

    pub fn deinit(self: *Self) void {
        if (self.testData) |data| {
            data.*.deinit();
            self.testData = null;
        }
    }

    pub fn run(self: *Self) void {
        if (self.testData) |data| {
            var solverInstance = Solver{ .result = null };
            const result = solverInstance.init(data.*.items);
            result.printResult();
        }
    }
};
