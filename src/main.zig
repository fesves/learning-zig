//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const mergeKSortedLists = @import("./leetcode/merge-k-sorted-lists.zig");
const ArrayList = std.ArrayList;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    // std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // Create nodes for the first linked list (1 -> 4 -> 5)
    var node1_1 = mergeKSortedLists.LinkedList{ .val = 1, .next = null };
    var node1_2 = mergeKSortedLists.LinkedList{ .val = 4, .next = null };
    var node1_3 = mergeKSortedLists.LinkedList{ .val = 5, .next = null };

    node1_1.next = &node1_2;
    node1_2.next = &node1_3;

    // Create nodes for the second linked list (1 -> 3 -> 4)
    var node2_1 = mergeKSortedLists.LinkedList{ .val = 1, .next = null };
    var node2_2 = mergeKSortedLists.LinkedList{ .val = 3, .next = null };
    var node2_3 = mergeKSortedLists.LinkedList{ .val = 4, .next = null };

    node2_1.next = &node2_2;
    node2_2.next = &node2_3;

    // Create nodes for the third linked list (2 -> 6)
    var node3_1 = mergeKSortedLists.LinkedList{ .val = 2, .next = null };
    var node3_2 = mergeKSortedLists.LinkedList{ .val = 6, .next = null };

    node3_1.next = &node3_2;
    const allocator = std.heap.page_allocator;
    var list = ArrayList(*mergeKSortedLists.LinkedList).init(allocator);
    defer list.deinit();

    try list.append(&node1_1);
    try list.append(&node2_1);
    try list.append(&node3_1);

    var kSortedListsInstance = mergeKSortedLists.KSortedLists{ .result = null };

    const result = kSortedListsInstance.init(list.items);
    result.printResult();
    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    //mergeKSortedLists.mergeKSortedLists(input: []mergeKSortedLists.mergeKSortedLists.LinkedList)

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
}
