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
index aa59897833..ac0c8cdadf 100644
--- a/attw.json
+++ b/attw.json
@@ -1439,6 +1439,7 @@
         "react-date-range/v0",
         "react-document-meta",
         "react-dom",
+        "react-dom/v18",
         "react-dynamic-number",
         "react-email-editor",
         "react-embed-gist",
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
index 9e6065022a..1ebfcb53cf 100644
--- a/types/react-dom/package.json
+++ b/types/react-dom/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react-dom",
-    "version": "18.3.9999",
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
index 9e6065022a..40089de1ec 100644
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
diff --git a/types/react-dom/v18/test/react-dom-tests.tsx b/types/react-dom/v18/test/react-dom-tests.tsx
index c2c350b288..8f92b1347b 100644
--- a/types/react-dom/v18/test/react-dom-tests.tsx
+++ b/types/react-dom/v18/test/react-dom-tests.tsx
@@ -371,7 +371,7 @@ function createRoot() {
     root.render(<div>initial render</div>);
     root.render(false);
 
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error React 19 feature
     ReactDOMClient.createRoot(document);
 }
 
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
index 842f165a8a..c1a64dad57 100644
--- a/types/react-is/package.json
+++ b/types/react-is/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react-is",
-    "version": "18.3.9999",
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
index 842f165a8a..013d4646aa 100644
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
index 85b28077d2..786b7f3a9f 100644
--- a/types/react-test-renderer/package.json
+++ b/types/react-test-renderer/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react-test-renderer",
-    "version": "18.3.9999",
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
index 85b28077d2..be0aa415c5 100644
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
index 02fcc1b90a..1c7b11bdd1 100644
--- a/types/react/package.json
+++ b/types/react/package.json
@@ -1,7 +1,7 @@
 {
     "private": true,
     "name": "@types/react",
-    "version": "18.3.9999",
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
index 02fcc1b90a..da83ed1d9f 100644
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
diff --git a/types/react/v18/test/elementAttributes.tsx b/types/react/v18/test/elementAttributes.tsx
index d81f0cd84c..dea2627170 100644
--- a/types/react/v18/test/elementAttributes.tsx
+++ b/types/react/v18/test/elementAttributes.tsx
@@ -133,26 +133,26 @@ const eventCallbacksTestCases = [
 
 function formActionsTest() {
     <form
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+        // @ts-expect-error Form Actions are not supported in React 18.
         action={formData => {
-            // $ExpectType FormData
+            // $ExpectType any
             formData;
         }}
     >
         <input type="text" name="title" defaultValue="Hello" />
         <input
             type="submit"
-            // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+            // @ts-expect-error Form Actions are not supported in React 18.
             formAction={formData => {
-                // $ExpectType FormData
+                // $ExpectType any
                 formData;
             }}
             value="Save"
         />
         <button
-            // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+            // @ts-expect-error Form Actions are not supported in React 18.
             formAction={formData => {
-                // $ExpectType FormData
+                // $ExpectType any
                 formData;
             }}
         >
diff --git a/types/react/v18/test/hooks.tsx b/types/react/v18/test/hooks.tsx
index d8ca70ca26..8d9f682af9 100644
--- a/types/react/v18/test/hooks.tsx
+++ b/types/react/v18/test/hooks.tsx
@@ -371,7 +371,7 @@ function useConcurrentHooks() {
 
         // The function must be synchronous, even if it can start an asynchronous update
         // it's no different from an useEffect callback in this respect
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+        // @ts-expect-error
         startTransition(async () => {});
 
         // Unlike Effect callbacks, though, there is no possible destructor to return
@@ -391,7 +391,8 @@ function startTransitionTest() {
         transitionToPage("/");
     });
 
-    // Will not type-check in a real project but accepted in DT tests since canary.d.ts is part of compilation.
+    // callback must be synchronous
+    // @ts-expect-error
     React.startTransition(async () => {});
 }
 
diff --git a/types/react/v18/test/index.ts b/types/react/v18/test/index.ts
index b601fe5abd..1449f0a990 100644
--- a/types/react/v18/test/index.ts
+++ b/types/react/v18/test/index.ts
@@ -768,11 +768,10 @@ class RenderChildren extends React.Component<{ children?: React.ReactNode }> {
     const emptyObject: React.ReactNode = {};
     // @ts-expect-error
     const plainObject: React.ReactNode = { dave: true };
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Promises as ReactNode is not supported in React 18.
     const promise: React.ReactNode = Promise.resolve("React");
 
     const asyncTests = async function asyncTests() {
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
         const node: Awaited<React.ReactNode> = await Promise.resolve("React");
     };
 
diff --git a/types/react/v18/test/tsx.tsx b/types/react/v18/test/tsx.tsx
index 7c259e2c02..2be4046a3b 100644
--- a/types/react/v18/test/tsx.tsx
+++ b/types/react/v18/test/tsx.tsx
@@ -561,7 +561,7 @@ imgProps.loading = "nonsense";
 // @ts-expect-error
 imgProps.decoding = "nonsense";
 type ImgPropsWithRef = React.ComponentPropsWithRef<"img">;
-// $ExpectType ((instance: HTMLImageElement | null) => void | (() => VoidOrUndefinedOnly)) | RefObject<HTMLImageElement> | null | undefined
+// $ExpectType ((instance: HTMLImageElement | null) => void) | RefObject<HTMLImageElement> | null | undefined
 type ImgPropsWithRefRef = ImgPropsWithRef["ref"];
 type ImgPropsWithoutRef = React.ComponentPropsWithoutRef<"img">;
 // $ExpectType false
@@ -691,7 +691,7 @@ function reactNodeTests() {
     <div>{createChildren()}</div>;
     // @ts-expect-error plain objects are not allowed
     <div>{{ dave: true }}</div>;
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Promises as ReactNode is not supported in React 18.
     <div>{Promise.resolve("React")}</div>;
 }
 
@@ -771,17 +771,18 @@ function elementTypeTests() {
     }
 
     const ReturnPromise = () => Promise.resolve("React");
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     const FCPromise: React.FC = ReturnPromise;
     class RenderPromise extends React.Component {
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+        // @ts-expect-error Async components are not supported in React 18.
         render() {
             return Promise.resolve("React");
         }
     }
 
     const ReturnPromiseReactNode = async ({ children }: { children?: React.ReactNode }) => children;
-    const FCPromiseReactNode: React.FC = ReturnReactNode;
+    // @ts-expect-error Async components are not supported in React 18.
+    const FCPromiseReactNode: React.FC = ReturnPromiseReactNode;
     class RenderPromiseReactNode extends React.Component<{ children?: React.ReactNode }> {
         // @ts-expect-error class components cannot render async
         async render() {
@@ -873,13 +874,13 @@ function elementTypeTests() {
     <RenderReactNode />;
     React.createElement(RenderReactNode);
 
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     <ReturnPromise />;
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     React.createElement(ReturnPromise);
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     <RenderPromise />;
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     React.createElement(RenderPromise);
 
     // @ts-expect-error See https://github.com/microsoft/TypeScript/issues/59111
@@ -948,8 +949,7 @@ function managingRefs() {
         }}
     />;
     <div
-        // Will not issue an error in a real project but does here since canary.d.ts is part of compilation.
-        // @ts-expect-error
+        // Ref cleanup is accidentally supported in React 18.
         ref={current => {
             // @ts-expect-error
             return function refCleanup(implicitAny) {
@@ -957,8 +957,7 @@ function managingRefs() {
         }}
     />;
     <div
-        // Will not issue an error in a real project but does here since canary.d.ts is part of compilation.
-        // @ts-expect-error
+        // Ref cleanup is accidentally supported in React 18.
         ref={current => {
             return function refCleanup(neverPassed: string) {
             };
diff --git a/types/react/v18/ts5.0/OTHER_FILES.txt b/types/react/v18/ts5.0/OTHER_FILES.txt
index 949a9c6213..d830e68845 100644
--- a/types/react/v18/ts5.0/OTHER_FILES.txt
+++ b/types/react/v18/ts5.0/OTHER_FILES.txt
@@ -1,4 +1,2 @@
-canary.d.ts
-experimental.d.ts
 jsx-dev-runtime.d.ts
 jsx-runtime.d.ts
diff --git a/types/react/v18/ts5.0/test/elementAttributes.tsx b/types/react/v18/ts5.0/test/elementAttributes.tsx
index d81f0cd84c..dea2627170 100644
--- a/types/react/v18/ts5.0/test/elementAttributes.tsx
+++ b/types/react/v18/ts5.0/test/elementAttributes.tsx
@@ -133,26 +133,26 @@ const eventCallbacksTestCases = [
 
 function formActionsTest() {
     <form
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+        // @ts-expect-error Form Actions are not supported in React 18.
         action={formData => {
-            // $ExpectType FormData
+            // $ExpectType any
             formData;
         }}
     >
         <input type="text" name="title" defaultValue="Hello" />
         <input
             type="submit"
-            // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+            // @ts-expect-error Form Actions are not supported in React 18.
             formAction={formData => {
-                // $ExpectType FormData
+                // $ExpectType any
                 formData;
             }}
             value="Save"
         />
         <button
-            // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+            // @ts-expect-error Form Actions are not supported in React 18.
             formAction={formData => {
-                // $ExpectType FormData
+                // $ExpectType any
                 formData;
             }}
         >
diff --git a/types/react/v18/ts5.0/test/hooks.tsx b/types/react/v18/ts5.0/test/hooks.tsx
index d8ca70ca26..8d9f682af9 100644
--- a/types/react/v18/ts5.0/test/hooks.tsx
+++ b/types/react/v18/ts5.0/test/hooks.tsx
@@ -371,7 +371,7 @@ function useConcurrentHooks() {
 
         // The function must be synchronous, even if it can start an asynchronous update
         // it's no different from an useEffect callback in this respect
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+        // @ts-expect-error
         startTransition(async () => {});
 
         // Unlike Effect callbacks, though, there is no possible destructor to return
@@ -391,7 +391,8 @@ function startTransitionTest() {
         transitionToPage("/");
     });
 
-    // Will not type-check in a real project but accepted in DT tests since canary.d.ts is part of compilation.
+    // callback must be synchronous
+    // @ts-expect-error
     React.startTransition(async () => {});
 }
 
diff --git a/types/react/v18/ts5.0/test/index.ts b/types/react/v18/ts5.0/test/index.ts
index b01d0c3a7f..71a73a1628 100644
--- a/types/react/v18/ts5.0/test/index.ts
+++ b/types/react/v18/ts5.0/test/index.ts
@@ -771,11 +771,10 @@ class RenderChildren extends React.Component<{ children?: React.ReactNode }> {
     const emptyObject: React.ReactNode = {};
     // @ts-expect-error
     const plainObject: React.ReactNode = { dave: true };
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Promises as ReactNode is not supported in React 18.
     const promise: React.ReactNode = Promise.resolve("React");
 
     const asyncTests = async function asyncTests() {
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
         const node: Awaited<React.ReactNode> = await Promise.resolve("React");
     };
 
diff --git a/types/react/v18/ts5.0/test/tsx.tsx b/types/react/v18/ts5.0/test/tsx.tsx
index fdd737b1bb..2d1fb846e9 100644
--- a/types/react/v18/ts5.0/test/tsx.tsx
+++ b/types/react/v18/ts5.0/test/tsx.tsx
@@ -561,7 +561,7 @@ imgProps.loading = "nonsense";
 // @ts-expect-error
 imgProps.decoding = "nonsense";
 type ImgPropsWithRef = React.ComponentPropsWithRef<"img">;
-// $ExpectType ((instance: HTMLImageElement | null) => void | (() => VoidOrUndefinedOnly)) | RefObject<HTMLImageElement> | null | undefined
+// $ExpectType ((instance: HTMLImageElement | null) => void) | RefObject<HTMLImageElement> | null | undefined
 type ImgPropsWithRefRef = ImgPropsWithRef["ref"];
 type ImgPropsWithoutRef = React.ComponentPropsWithoutRef<"img">;
 // $ExpectType false
@@ -691,7 +691,7 @@ function reactNodeTests() {
     <div>{createChildren()}</div>;
     // @ts-expect-error plain objects are not allowed
     <div>{{ dave: true }}</div>;
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Promises as ReactNode is not supported in React 18.
     <div>{Promise.resolve("React")}</div>;
 }
 
@@ -763,7 +763,7 @@ function elementTypeTests() {
     // @ts-expect-error experimental release channel only
     const FCPromise: React.FC = ReturnPromise;
     class RenderPromise extends React.Component {
-        // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+        // @ts-expect-error Async components are not supported in React 18.
         render() {
             return Promise.resolve("React");
         }
@@ -874,13 +874,13 @@ function elementTypeTests() {
     <RenderReactNode />;
     React.createElement(RenderReactNode);
 
-    // @ts-expect-error Only available in experimental release channel
+    // @ts-expect-error Async components are not supported in React 18.
     <ReturnPromise />;
-    // @ts-expect-error Only available in experimental release channel
+    // @ts-expect-error Async components are not supported in React 18.
     React.createElement(ReturnPromise);
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     <RenderPromise />;
-    // Will not type-check in a real project but accepted in DT tests since experimental.d.ts is part of compilation.
+    // @ts-expect-error Async components are not supported in React 18.
     React.createElement(RenderPromise);
 
     // @ts-expect-error See https://github.com/microsoft/TypeScript/issues/59111
@@ -949,8 +949,7 @@ function managingRefs() {
         }}
     />;
     <div
-        // Will not issue an error in a real project but does here since canary.d.ts is part of compilation.
-        // @ts-expect-error
+        // Ref cleanup is accidentally supported in React 18.
         ref={current => {
             // @ts-expect-error
             return function refCleanup(implicitAny) {
@@ -958,8 +957,7 @@ function managingRefs() {
         }}
     />;
     <div
-        // Will not issue an error in a real project but does here since canary.d.ts is part of compilation.
-        // @ts-expect-error
+        // Ref cleanup is accidentally supported in React 18.
         ref={current => {
             return function refCleanup(neverPassed: string) {
             };
diff --git a/types/react/v18/ts5.0/tsconfig.json b/types/react/v18/ts5.0/tsconfig.json
index 61a90f2187..4a67b345fc 100644
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
index 61a90f2187..4a67b345fc 100644
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