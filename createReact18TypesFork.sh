#!/bin/bash -ex
pushd types

for file in $(git ls-files "react/*"); do 
  dir=$(dirname "${file#react/}")
  mkdir -p "react/v18/$dir"
  cp "$file" "react/v18/$dir"
done

rm -rf react/v18/v15
rm -rf react/v18/v16
rm -rf react/v18/v17
rm react/v18/canary.d.ts
rm react/v18/experimental.d.ts
rm react/v18/test/canary.tsx
rm react/v18/test/experimental.tsx
rm react/v18/ts5.0/canary.d.ts
rm react/v18/ts5.0/experimental.d.ts
rm react/v18/ts5.0/test/canary.tsx
rm react/v18/ts5.0/test/experimental.tsx

# react-dom
for file in $(git ls-files "react-dom/*"); do 
  dir=$(dirname "${file#react-dom/}")
  mkdir -p "react-dom/v18/$dir"
  cp "$file" "react-dom/v18/$dir"
done

rm -rf react-dom/v18/v15
rm -rf react-dom/v18/v16
rm -rf react-dom/v18/v17
rm react-dom/v18/canary.d.ts
rm react-dom/v18/experimental.d.ts
rm react-dom/v18/test/canary-tests.tsx
rm react-dom/v18/test/experimental-tests.tsx

# react-is
for file in $(git ls-files "react-is/*"); do 
  dir=$(dirname "${file#react-is/}")
  mkdir -p "react-is/v18/$dir"
  cp "$file" "react-is/v18/$dir"
done

rm -rf react-is/v18/v16
rm -rf react-is/v18/v17
rm react-is/v18/canary.d.ts
rm react-is/v18/test/canary-tests.tsx

# react-test-renderer
for file in $(git ls-files "react-test-renderer/*"); do 
  dir=$(dirname "${file#react-test-renderer/}")
  mkdir -p "react-test-renderer/v18/$dir"
  cp "$file" "react-test-renderer/v18/$dir"
done

rm -rf react-test-renderer/v18/v15
rm -rf react-test-renderer/v18/v16
rm -rf react-test-renderer/v18/v17

popd

# Stage so that it's easier to amend to patch if apply fails.
git add -A

git apply --reject << 'EOF'
diff --git a/attw.json b/attw.json
index 7edc602be9..d2e2aa058f 100644
--- a/attw.json
+++ b/attw.json
@@ -1508,6 +1508,7 @@
         "react-document-meta",
         "react-document-title",
         "react-dom",
+        "react-dom/v18",
         "react-dual-listbox",
         "react-dynamic-number",
         "react-email-editor",
diff --git a/types/react-dom/.npmignore b/types/react-dom/.npmignore
index 3d6bac44b6..c7676c2d49 100644
--- a/types/react-dom/.npmignore
+++ b/types/react-dom/.npmignore
@@ -6,3 +6,4 @@
 /v15/
 /v16/
 /v17/
+/v18/
diff --git a/types/react-dom/package.json b/types/react-dom/package.json
index 789ec850d8..1ebfcb53cf 100644
--- a/types/react-dom/package.json
+++ b/types/react-dom/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react-dom",
-    "version": "18.2.9999",
+    "version": "19.0.9999",
     "projects": [
         "https://reactjs.org"
     ],
diff --git a/types/react-dom/v18/.npmignore b/types/react-dom/v18/.npmignore
index 3d6bac44b6..93e307400a 100644
--- a/types/react-dom/v18/.npmignore
+++ b/types/react-dom/v18/.npmignore
@@ -3,6 +3,3 @@
 !**/*.d.cts
 !**/*.d.mts
 !**/*.d.*.ts
-/v15/
-/v16/
-/v17/
diff --git a/types/react-dom/v18/package.json b/types/react-dom/v18/package.json
index 789ec850d8..3ddfe4ea82 100644
--- a/types/react-dom/v18/package.json
+++ b/types/react-dom/v18/package.json
@@ -16,21 +16,11 @@
                 "default": "./client.d.ts"
             }
         },
-        "./canary": {
-            "types": {
-                "default": "./canary.d.ts"
-            }
-        },
         "./server": {
             "types": {
                 "default": "./server.d.ts"
             }
         },
-        "./experimental": {
-            "types": {
-                "default": "./experimental.d.ts"
-            }
-        },
         "./test-utils": {
             "types": {
                 "default": "./test-utils/index.d.ts"
@@ -38,7 +28,7 @@
         }
     },
     "dependencies": {
-        "@types/react": "*"
+        "@types/react": "^18"
     },
     "devDependencies": {
         "@types/react-dom": "workspace:."
diff --git a/types/react-dom/v18/tsconfig.json b/types/react-dom/v18/tsconfig.json
index 81e804f9ce..200f7d2c8c 100644
--- a/types/react-dom/v18/tsconfig.json
+++ b/types/react-dom/v18/tsconfig.json
@@ -1,9 +1,7 @@
 {
     "files": [
         "index.d.ts",
-        "test/react-dom-tests.tsx",
-        "test/experimental-tests.tsx",
-        "test/canary-tests.tsx"
+        "test/react-dom-tests.tsx"
     ],
     "compilerOptions": {
         "module": "node16",
@@ -18,6 +16,11 @@
         "types": [],
         "noEmit": true,
         "forceConsistentCasingInFileNames": true,
-        "jsx": "preserve"
+        "jsx": "preserve",
+        "paths": {
+            "react-dom": [
+                "./index.d.ts"
+            ]
+        }
     }
 }
diff --git a/types/react-is/.npmignore b/types/react-is/.npmignore
index 56cc010f51..dea6c52641 100644
--- a/types/react-is/.npmignore
+++ b/types/react-is/.npmignore
@@ -5,3 +5,4 @@
 !**/*.d.*.ts
 /v16/
 /v17/
+/v18/
diff --git a/types/react-is/package.json b/types/react-is/package.json
index bfc610417f..c1a64dad57 100644
--- a/types/react-is/package.json
+++ b/types/react-is/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react-is",
-    "version": "18.2.9999",
+    "version": "19.0.9999",
     "projects": [
         "https://reactjs.org/"
     ],
diff --git a/types/react-is/v18/.npmignore b/types/react-is/v18/.npmignore
index 56cc010f51..93e307400a 100644
--- a/types/react-is/v18/.npmignore
+++ b/types/react-is/v18/.npmignore
@@ -3,5 +3,3 @@
 !**/*.d.cts
 !**/*.d.mts
 !**/*.d.*.ts
-/v16/
-/v17/
diff --git a/types/react-is/v18/package.json b/types/react-is/v18/package.json
index bfc610417f..b3945918a0 100644
--- a/types/react-is/v18/package.json
+++ b/types/react-is/v18/package.json
@@ -6,10 +6,10 @@
         "https://reactjs.org/"
     ],
     "dependencies": {
-        "@types/react": "*"
+        "@types/react": "^18"
     },
     "devDependencies": {
-        "@types/react-dom": "*",
+        "@types/react-dom": "^18",
         "@types/react-is": "workspace:."
     },
     "owners": [
diff --git a/types/react-is/v18/tsconfig.json b/types/react-is/v18/tsconfig.json
index f2311edb57..a13e47bbf3 100644
--- a/types/react-is/v18/tsconfig.json
+++ b/types/react-is/v18/tsconfig.json
@@ -16,7 +16,6 @@
     },
     "files": [
         "index.d.ts",
-        "test/react-is-tests.tsx",
-        "test/canary-tests.tsx"
+        "test/react-is-tests.tsx"
     ]
 }
diff --git a/types/react-test-renderer/.npmignore b/types/react-test-renderer/.npmignore
index 3d6bac44b6..c7676c2d49 100644
--- a/types/react-test-renderer/.npmignore
+++ b/types/react-test-renderer/.npmignore
@@ -6,3 +6,4 @@
 /v15/
 /v16/
 /v17/
+/v18/
diff --git a/types/react-test-renderer/package.json b/types/react-test-renderer/package.json
index 127a164a97..786b7f3a9f 100644
--- a/types/react-test-renderer/package.json
+++ b/types/react-test-renderer/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react-test-renderer",
-    "version": "18.0.9999",
+    "version": "19.0.9999",
     "projects": [
         "https://facebook.github.io/react/"
     ],
diff --git a/types/react-test-renderer/v18/.npmignore b/types/react-test-renderer/v18/.npmignore
index 3d6bac44b6..93e307400a 100644
--- a/types/react-test-renderer/v18/.npmignore
+++ b/types/react-test-renderer/v18/.npmignore
@@ -3,6 +3,3 @@
 !**/*.d.cts
 !**/*.d.mts
 !**/*.d.*.ts
-/v15/
-/v16/
-/v17/
diff --git a/types/react-test-renderer/v18/package.json b/types/react-test-renderer/v18/package.json
index 127a164a97..8f4fcf3cc6 100644
--- a/types/react-test-renderer/v18/package.json
+++ b/types/react-test-renderer/v18/package.json
@@ -6,7 +6,7 @@
         "https://facebook.github.io/react/"
     ],
     "dependencies": {
-        "@types/react": "*"
+        "@types/react": "^18"
     },
     "devDependencies": {
         "@types/react-test-renderer": "workspace:."
diff --git a/types/react/.npmignore b/types/react/.npmignore
index 3d6bac44b6..c7676c2d49 100644
--- a/types/react/.npmignore
+++ b/types/react/.npmignore
@@ -6,3 +6,4 @@
 /v15/
 /v16/
 /v17/
+/v18/
diff --git a/types/react/package.json b/types/react/package.json
index 5e44959bca..123d6826de 100644
--- a/types/react/package.json
+++ b/types/react/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react",
-    "version": "18.2.9999",
+    "version": "19.0.9999",
     "projects": [
         "https://react.dev/"
     ],
diff --git a/types/react/v18/.npmignore b/types/react/v18/.npmignore
index 3d6bac44b6..93e307400a 100644
--- a/types/react/v18/.npmignore
+++ b/types/react/v18/.npmignore
@@ -3,6 +3,3 @@
 !**/*.d.cts
 !**/*.d.mts
 !**/*.d.*.ts
-/v15/
-/v16/
-/v17/
diff --git a/types/react/v18/package.json b/types/react/v18/package.json
index 5e44959bca..7af448dbb7 100644
--- a/types/react/v18/package.json
+++ b/types/react/v18/package.json
@@ -14,22 +14,6 @@
                 "default": "./index.d.ts"
             }
         },
-        "./canary": {
-            "types@<=5.0": {
-                "default": "./ts5.0/canary.d.ts"
-            },
-            "types": {
-                "default": "./canary.d.ts"
-            }
-        },
-        "./experimental": {
-            "types@<=5.0": {
-                "default": "./ts5.0/experimental.d.ts"
-            },
-            "types": {
-                "default": "./experimental.d.ts"
-            }
-        },
         "./jsx-runtime": {
             "types@<=5.0": {
                 "default": "./ts5.0/jsx-runtime.d.ts"
diff --git a/types/react/v18/ts5.0/OTHER_FILES.txt b/types/react/v18/ts5.0/OTHER_FILES.txt
index 949a9c6213..d830e68845 100644
--- a/types/react/v18/ts5.0/OTHER_FILES.txt
+++ b/types/react/v18/ts5.0/OTHER_FILES.txt
@@ -1,4 +1,2 @@
-canary.d.ts
-experimental.d.ts
 jsx-dev-runtime.d.ts
 jsx-runtime.d.ts
diff --git a/types/react/v18/ts5.0/tsconfig.json b/types/react/v18/ts5.0/tsconfig.json
index 4fd7cfece3..6791beaaa2 100644
--- a/types/react/v18/ts5.0/tsconfig.json
+++ b/types/react/v18/ts5.0/tsconfig.json
@@ -8,9 +8,7 @@
         "test/cssProperties.tsx",
         "test/elementAttributes.tsx",
         "test/managedAttributes.tsx",
-        "test/hooks.tsx",
-        "test/experimental.tsx",
-        "test/canary.tsx"
+        "test/hooks.tsx"
     ],
     "compilerOptions": {
         "module": "commonjs",
@@ -25,6 +23,11 @@
         "types": [],
         "noEmit": true,
         "forceConsistentCasingInFileNames": true,
-        "jsx": "preserve"
+        "jsx": "preserve",
+        "paths": {
+            "react": [
+                "./index.d.ts"
+            ]
+        }
     }
 }
diff --git a/types/react/v18/tsconfig.json b/types/react/v18/tsconfig.json
index 4fd7cfece3..6791beaaa2 100644
--- a/types/react/v18/tsconfig.json
+++ b/types/react/v18/tsconfig.json
@@ -8,9 +8,7 @@
         "test/cssProperties.tsx",
         "test/elementAttributes.tsx",
         "test/managedAttributes.tsx",
-        "test/hooks.tsx",
-        "test/experimental.tsx",
-        "test/canary.tsx"
+        "test/hooks.tsx"
     ],
     "compilerOptions": {
         "module": "commonjs",
@@ -25,6 +23,11 @@
         "types": [],
         "noEmit": true,
         "forceConsistentCasingInFileNames": true,
-        "jsx": "preserve"
+        "jsx": "preserve",
+        "paths": {
+            "react": [
+                "./index.d.ts"
+            ]
+        }
     }
 }

EOF