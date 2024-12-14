//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const KSortedListsRunner = @import("./leetcode/merge-k-sorted-lists.zig").Runner;
const ArrayList = std.ArrayList;

pub fn main() !void {
    var kSortedRunner = KSortedListsRunner{ .testData = null };
    _ = try kSortedRunner.init();
    defer kSortedRunner.deinit();
    kSortedRunner.run();
    std.debug.print("finished: {}\n ", .{9});

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
