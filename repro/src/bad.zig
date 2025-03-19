const std = @import("std");
const Progress = std.Progress;
const Thread = std.Thread;

pub fn main() !void {
    var args = std.process.ArgIteratorPosix.init();
    if (args.count != 3) {
        std.debug.print("Usage: repro_bad num_threads steps_per_node\n", .{});
        return;
    }
    _ = args.skip();
    const num_threads = try std.fmt.parseInt(usize, args.next().?, 10);
    if (num_threads > 200) {
        std.debug.print("max 200 threads\n", .{});
        return;
    }
    const steps_per_node = try std.fmt.parseInt(usize, args.next().?, 10);

    var root_progress = Progress.start(.{ .root_name = "root" });
    var threads: [200]Thread = undefined;
    for (0..num_threads) |i| {
        threads[i] = try Thread.spawn(.{}, spam, .{ &root_progress, i, steps_per_node });
    }
    for (0..num_threads) |i| {
        std.debug.print("joining {d}\n", .{i});
        threads[i].join();
    }
}

fn spam(root_progress: *Progress.Node, threadnum: usize, steps_per_node: usize) void {
    var name: [5]u8 = undefined;
    const name_len = std.fmt.formatIntBuf(name[0..name.len], threadnum, 10, .lower, .{ .width = 2 });
    while (true) {
        const node = root_progress.start(name[0..name_len], steps_per_node);
        for (0..steps_per_node) |_| {
            node.completeOne();
        }
        node.end();
    }
}
