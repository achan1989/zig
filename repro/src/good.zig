const std = @import("std");
const Progress = std.Progress;
const Thread = std.Thread;

const num_threads = 5;
const steps_per_node = 0;
const sleep_1s = 1_000_000_000;

pub fn main() !void {
    var root_progress = Progress.start(.{ .root_name = "root" });
    var threads: [num_threads]Thread = undefined;
    for (0..num_threads) |i| {
        threads[i] = try Thread.spawn(.{}, spam, .{ &root_progress, i });
        Thread.sleep(sleep_1s);
    }
    Thread.sleep(sleep_1s * 14);
    for (0..num_threads) |i| {
        std.debug.print("joining {d}\n", .{i});
        threads[i].join();
    }
}

fn spam(root_progress: *Progress.Node, threadnum: usize) void {
    var name: [2]u8 = undefined;
    const name_len = std.fmt.formatIntBuf(name[0..name.len], threadnum, 10, .lower, .{ .width = 2 });

    const node = root_progress.start(name[0..name_len], steps_per_node);
    Thread.sleep(sleep_1s * 10);
    for (0..steps_per_node) |_| {
        node.completeOne();
    }
    node.end();
}
