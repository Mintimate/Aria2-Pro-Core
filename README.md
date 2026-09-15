# Aria2 Pro Core

[![LICENSE](https://img.shields.io/github/license/Mintimate/Aria2-Pro-Core?style=flat-square)](https://github.com/Mintimate/Aria2-Pro-Core/blob/master/LICENSE)
![GitHub All Releases](https://img.shields.io/github/downloads/Mintimate/Aria2-Pro-Core/total?label=Downlaods&style=flat-square&color=red)
[![GitHub Stars](https://img.shields.io/github/stars/Mintimate/Aria2-Pro-Core.svg?style=flat-square&label=Stars&logo=github)](https://github.com/Mintimate/Aria2-Pro-Core/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Mintimate/Aria2-Pro-Core.svg?style=flat-square&label=Forks&logo=github)](https://github.com/Mintimate/Aria2-Pro-Core/fork)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Mintimate/Aria2-Pro-Core/Aria2%20Builder?label=Actions&logo=github&style=flat-square)

Patched aria2 binaries for GNU/Linux, macOS (Apple Silicon / Intel), and Windows (x64 / x86).

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/Mintimate/Aria2-Pro-Core?style=for-the-badge)](https://github.com/Mintimate/Aria2-Pro-Core/releases/latest)

## Changes

* option `max-connection-per-server`: change maximum value to `∞`
* option `min-split-size`: change minimum value to `1K`
* option `piece-length`: change minimum value to `1K`
* download: retry on slow speed (`lowest-speed-limit`) and connection close
* download: add option `retry-on-400` to retry on http 400 bad request, which only effective if `retry-wait` > 0
* download: add option `retry-on-403` to retry on http 403 forbidden, which only effective if `retry-wait` > 0
* download: add option `retry-on-406` to retry on http 406 not acceptable, which only effective if `retry-wait` > 0
* download: add option `retry-on-unknown` to retry on unknown status code, which only effective if `retry-wait` > 0
* http: add option `http-want-digest` to choose whether to send the generated `Want-Digest` HTTP header or not (Not send by default)

## Installing

每次 `master` 分支的全部构建与测试通过后，工作流会自动发布到 [GitHub Releases](https://github.com/Mintimate/Aria2-Pro-Core/releases)。请根据操作系统和 CPU 架构下载：

| 系统 | CPU 架构 | Release 文件 |
| --- | --- | --- |
| Linux | x64 / amd64 | `aria2-static-linux-amd64.tar.gz` |
| Linux | ARM64 | `aria2-static-linux-arm64.tar.gz` |
| Linux | ARMv7 / armhf | `aria2-static-linux-armhf.tar.gz` |
| Linux | x86 / i386 | `aria2-static-linux-i386.tar.gz` |
| macOS | Apple Silicon | `aria2-static-macos-arm64.tar.gz` |
| macOS | Intel x64 | `aria2-static-macos-x64.tar.gz` |
| Windows | x64 | `aria2-windows-x64.zip` |
| Windows | x86（32 位） | `aria2-windows-x86.zip` |

### Linux / macOS

解压对应的 `.tar.gz`，运行 `./aria2c --version`。需要全局使用时，可将 `aria2c` 放到 PATH 中的目录（例如 `/usr/local/bin`）。macOS 包静态链接第三方依赖，仍使用 macOS 系统库；它不需要安装 Homebrew。

### Windows x64 / x86

完整解压 ZIP，在 PowerShell 中运行 `./aria2c.exe --version`。请保留与 EXE 同目录的 DLL 和许可证文件；它们包含运行所需的第三方库，无需安装 MSYS2 或 MinGW。HTTPS 使用 Windows 系统证书存储。

发布前会检查 macOS 和 Windows 解压后的程序版本及 HTTPS 下载内容；Windows 额外校验 EXE / DLL 的 CPU 架构，并在不含 MSYS2 的 PATH 下运行，macOS 检查没有依赖构建机上的 Homebrew 库。Windows x86 在 x64 runner 上测试，不代表已验证所有旧版 32 位 Windows 系统。

### Uninstall
```shell
sudo rm -f /usr/local/bin/aria2c
```

## Building

### with script

Download script, execute script.
> **TIPS:** In today's containerization of everything, this is not recommended.
```shell
git clone https://github.com/Mintimate/Aria2-Pro-Core
cd Aria2-Pro-Core
bash aria2-gnu-linux-build.sh
```

### with docker

> **TIPS:** Docker minimum version 19.03, you can also use [buildx](https://github.com/docker/buildx).

Build Aria2 for current architecture platforms.
```shell
DOCKER_BUILDKIT=1 docker build \
    -o type=local,dest=. \
    github.com/Mintimate/Aria2-Pro-Core
```

**`dest`** can define the output directory. If there are no changes, there will be an archive file in the current directory when the build is completed.
```
$ ls -l 
-rw-r--r-- 1 p3terx p3terx 3744106 Jan 17 20:24 aria2-1.35.0-static-linux-amd64.tar.gz
```

Cross build Aria2 for other platforms, e.g.:
```
DOCKER_BUILDKIT=1 docker build \
    --build-arg BUILDER_IMAGE=debian:12 \
    --build-arg BUILD_SCRIPT=aria2-gnu-linux-cross-build-armhf.sh \
    -o type=local,dest=. \
    github.com/Mintimate/Aria2-Pro-Core
```
> **`BUILDER_IMAGE`** variable defines the system image used for the build. In general, platforms other than `armhf` don't require it.
> **`BUILD_SCRIPT`** variable defines the script used for the cross build.

## External links

### Aria2

* [Aria2 homepage](https://aria2.github.io/)
* [Aria2 documentation](https://aria2.github.io/manual/en/html/)
* [Aria2 source code (Github)](https://github.com/aria2/aria2)

### Used external libraries

* [zlib](http://www.zlib.net/)
* [Expat](https://libexpat.github.io/)
* [c-ares](http://c-ares.haxx.se/)
* [SQLite](http://www.sqlite.org/)
* [OpenSSL](http://www.openssl.org/)
* [libssh2](http://www.libssh2.org/)
* [jemalloc](http://jemalloc.net/)

### Credits

* [q3aql/aria2-static-builds](https://github.com/q3aql/aria2-static-builds)
* [myfreeer/aria2-build-msys2](https://github.com/myfreeer/aria2-build-msys2)

## Licence

[![GPLv3](https://www.gnu.org/graphics/gplv3-127x51.png)](https://github.com/Mintimate/Aria2-Pro-Core/blob/master/LICENSE)

## Native builds

GitHub Actions builds macOS arm64 on `macos-14`, macOS x64 on `macos-15-intel`, and Windows x64 / x86 on `windows-2022` with MSYS2/MinGW. See [the workflow](.github/workflows/aria2-builer.yml) for the dependency installation steps. Windows uses `aria2-windows-build.sh`; the Linux script is not a Windows build entry point.

本地构建 Windows 时，在安装好对应架构依赖的 MSYS2 环境中执行：

```bash
# MINGW64 环境（默认构建 x64）
bash aria2-windows-build.sh

# MINGW32 环境（构建 x86 / 32 位）
WINDOWS_ARCH=x86 bash aria2-windows-build.sh
```

构建脚本会检查编译器目标，并按架构隔离源码与打包目录，避免 x64 / x86 文件混用。MINGW32 已被 MSYS2 标记为弃用，仍保留用于本项目的 32 位兼容构建，后续依赖可用性需持续关注。
