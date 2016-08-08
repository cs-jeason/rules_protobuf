load("//bzl:protoc.bzl", "protoc")
load("//bzl:cpp/descriptor.bzl", CPP = "DESCRIPTOR")

def cc_proto_library(
    name,
    protos,
    lang = CPP,
    srcs = [],
    imports = [],
    visibility = None,
    testonly = 0,
    protoc_executable = None,
    protobuf_plugin_executable = None,
    with_grpc = False,
    deps = [],
    hdrs = [],
    **kwargs):

  result = protoc(
    lang = lang,
    name = name + "_pb",
    protos = protos,
    protoc_executable = protoc_executable,
    protobuf_plugin_executable = protobuf_plugin_executable,
    visibility = visibility,
    testonly = testonly,
    imports = imports,
    verbose = True,
    with_grpc = with_grpc,
  )

  cc_deps = [str(Label(dep)) for dep in getattr(lang.protobuf, "compile_deps", [])]
  if with_grpc:
    cc_deps += [str(Label(dep)) for dep in getattr(lang.grpc, "compile_deps", [])]

  native.cc_library(
    name = name,
    srcs = srcs + result.outs,
    deps = deps + cc_deps,
    hdrs = result.hdrs + hdrs,
    **kwargs
  )