# `handbrake`

## Local changes

- Add Monterey-era macOS compatibility shims around newer VideoToolbox and
  Metal APIs.
- On macOS 12 and older:
  replace `rotate_vt.c` with a compatibility stub that disables the
  VideoToolbox rotation path cleanly.
- On newer SDKs built from older systems:
  define missing VideoToolbox constants when the active SDK headers do not
  provide them.
- Replace direct `supportsFamily:MTLGPUFamilyMetal3` checks with a local helper
  that compiles on older SDKs.

## Why

- Current HandBrake code expects newer macOS SDK symbols than legacy Intel
  Monterey systems provide.
- The local patch keeps the formula buildable by removing or guarding the code
  paths that require unavailable APIs instead of trying to emulate full newer
  framework behavior.

## Patch

```diff
@@
+    if OS.mac?
+      if MacOS.version <= :monterey
+        rm buildpath/"libhb/platform/macosx/rotate_vt.c"
+        (buildpath/"libhb/platform/macosx/rotate_vt.c").write <<~"EOS"
+          /* rotate_vt.c
+             Compatibility stub for SDKs older than macOS 13 where VTPixelRotationSession APIs do not exist.
+           */
+          ...
+        EOS
+        inreplace "libhb/platform/macosx/vt_common.c",
+                  "        replace_filter(job, HB_FILTER_ROTATE, HB_FILTER_ROTATE_VT);\n",
+                  ""
+      else
+        inreplace "libhb/platform/macosx/rotate_vt.c" do |s|
+          ...
+        end
+      end
+      inreplace "libhb/platform/macosx/encvt.c" do |s|
+        ...
+      end
+      inreplace ["libhb/platform/macosx/comb_detect_vt.m", "libhb/platform/macosx/motion_metric_vt.m"] do |s|
+        s.gsub!(/supportsFamily:MTLGPUFamilyMetal3/, "supportsHBMetal3Family")
+      end
+    end
```

The actual patch is large; this excerpt shows the compatibility block that was
added around the newer macOS VideoToolbox and Metal APIs.
