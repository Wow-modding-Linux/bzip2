const std = @import("std");

const version = "1.1.0";
const lib_version = std.SemanticVersion{
    .major = 1,
    .minor = 0,
    .patch = 9,
};

// retrieved from https://github.com/Wow-modding-Linux/bzip2/blob/66c46b8c9436613fd81bc5d03f63a61933a4dcc3/CMakeLists.txt#L194-L234
const ccFlags = &.{
    "-fPIC",               "-Wall",
    "-Wextra",             "-Wmissing-prototypes",
    "-Wstrict-prototypes", "-Wmissing-declarations",
    "-Wpointer-arith",     "-Wdeclaration-after-statement",
    "-Wformat-security",   "-Wwrite-strings",
    "-Wshadow",            "-Winline",
    "-Wnested-externs",    "-Wfloat-equal",
    "-Wundef",             "-Wendif-labels",
    "-Wempty-body",        "-Wcast-align",
    "-Wclobbered",         "-Wvla",
    "-Wpragmas",           "-Wunreachable-code",
    "-Waddress",           "-Wattributes",
    "-Wdiv-by-zero",       "-Wconversion",
    "-Wformat-nonliteral", "-Wmissing-field-initializers",
    "-Wmissing-noreturn",  "-Wsign-conversion",
    "-Wunused-macros",     "-Wunused-parameter",
    "-Wredundant-decls",   "-Wno-format-nonliteral",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const bzip2 = b.addSharedLibrary(.{
        .name = "bz2",
        .target = target,
        .optimize = optimize,
        .version = lib_version,
    });

    const bzip2_h = b.addConfigHeader(
        .{
            .style = .blank,
            .include_path = "bz_version.h",
        },
        .{
            .BZ_VERSION = version,
        },
    );
    bzip2.addConfigHeader(bzip2_h);
    bzip2.addCSourceFiles(.{
        .files = &.{
            "blocksort.c",
            "bzlib.c",
            "compress.c",
            "crctable.c",
            "decompress.c",
            "huffman.c",
            "randtable.c",
        },
        .flags = ccFlags,
    });
    bzip2.linkLibC();
    b.installArtifact(bzip2);
}
