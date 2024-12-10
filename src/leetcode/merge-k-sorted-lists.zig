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

        self.result = data[0];
        if (length >= 1) for (data[1..]) |item| {
            self.insert(item);
        };
        return self;
    }

    pub fn printResult(self: *Self) void {
        var current = self.result;
        while (current) |node| {
            std.debug.print("{} -> ", .{node.val});
            current = node.next;
        }
    }

    fn insert(self: *Self, item: *LinkedList) void {
        var currentInsertion: ?*LinkedList = item;

        if (self.result) |result| if (currentInsertion) |insertion| if (result.*.val > insertion.*.val) {
            const temp = insertion.*.next;
            insertion.*.next = result;
            self.result = insertion;
            currentInsertion = temp;
        };

        var currentResultItem = self.result;
        while (currentInsertion) |insertion| {
            if (currentResultItem) |resultItem| {
                if (resultItem.*.next == null) {
                    resultItem.*.next = insertion;
                    currentInsertion = insertion.*.next;
                } else {
                    if (resultItem.*.next) |next| if (next.*.val > insertion.*.val) {
                        // code...
                        const currentNext = next;
                        resultItem.*.next = insertion;
                        insertion.*.next = currentNext; // change thid directly to next and remove line 53
                        currentInsertion = insertion.*.next;
                    };
                }

                currentResultItem = resultItem.*.next;
            } else {
                std.debug.print("error happened\n", .{});
                break;
            }
        }
    }
};
