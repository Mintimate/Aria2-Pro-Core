#!/usr/bin/env bash
# Build a native Windows application with MinGW, without sudo or MSYS DLLs.
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WINDOWS_ARCH="${WINDOWS_ARCH:-x64}"
case "$WINDOWS_ARCH" in
    x64) WINDOWS_HOST=x86_64-w64-mingw32 ;;
    x86) WINDOWS_HOST=i686-w64-mingw32 ;;
    *)
        echo "Unsupported Windows architecture: $WINDOWS_ARCH (expected x64 or x86)." >&2
        exit 1
        ;;
esac
# Fail before downloading sources if the selected MSYS2 toolchain is wrong.
export CC=gcc CXX=g++
for compiler in "$CC" "$CXX"; do
    compiler_host=$("$compiler" -dumpmachine)
    if [ "$compiler_host" != "$WINDOWS_HOST" ]; then
        echo "Expected $WINDOWS_HOST, but $compiler targets $compiler_host. Use the matching MSYS2 MinGW environment." >&2
        exit 1
    fi
done
: "${MINGW_PREFIX:?Run in the matching MSYS2 MinGW environment.}"
ARIA2_CODE_DIR="$SCRIPT_DIR/.build/windows/$WINDOWS_ARCH/aria2"
OUTPUT_DIR="$SCRIPT_DIR/output"
STAGE_DIR="$SCRIPT_DIR/.build/windows/$WINDOWS_ARCH/package"
export SKIP_PATCHES=1
source "$SCRIPT_DIR/snippet/aria2-code"
ARIA2_CODE_GET
./configure --host="$WINDOWS_HOST" \
    --disable-nls --without-included-gettext --without-cppunit \
    --with-libz --with-libcares --with-libexpat --without-libxml2 \
    --with-wintls --without-openssl --without-gnutls \
    --without-libgcrypt --without-libnettle --with-libgmp \
    --with-libssh2 --with-sqlite3 --without-jemalloc \
    ARIA2_STATIC=yes
make -j"$(nproc)"
mkdir -p "$STAGE_DIR" "$OUTPUT_DIR"
cp src/aria2c.exe "$STAGE_DIR/"
strip "$STAGE_DIR/aria2c.exe"
# Include the transitive MinGW DLL dependencies. Windows system DLLs are
# provided by the OS and are deliberately not redistributed.
cp "$MINGW_PREFIX/bin/"*.dll "$STAGE_DIR/"
pending=("$STAGE_DIR/aria2c.exe")
while ((${#pending[@]})); do
    binary=${pending[0]}
    pending=("${pending[@]:1}")
    while read -r dll; do
        if [ -f "$MINGW_PREFIX/bin/$dll" ] && [ ! -f "$STAGE_DIR/$dll" ]; then
            cp "$MINGW_PREFIX/bin/$dll" "$STAGE_DIR/"
            pending+=("$STAGE_DIR/$dll")
        fi
    done < <(objdump -p "$binary" | awk '/DLL Name:/ {print $3}')
done
if [ -f "$STAGE_DIR/msys-2.0.dll" ]; then
    echo 'The executable must be a native Windows application.' >&2
    exit 1
fi
cp "$SCRIPT_DIR/LICENSE" "$STAGE_DIR/"
# Keep the dependency copyright notices alongside the bundled libraries.
cp -R "$MINGW_PREFIX/share/licenses" "$STAGE_DIR/dependency-licenses"
cd "$STAGE_DIR"
zip -qr "$OUTPUT_DIR/aria2-windows-$WINDOWS_ARCH.zip" .
