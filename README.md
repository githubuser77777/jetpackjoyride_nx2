<div align="center">

<img src="extras/banner.png" alt="Jetpack Joyride banner" width="35%">

</div>

<h1 align="center">Jetpack Joyride for Nintendo Switch</h1>

An unofficial homebrew wrapper for the Android ARM64 release of **Jetpack
Joyride 1.104.1**. It loads the game's native ARM64 library and provides the
Android, JNI, input, graphics, and audio services that it needs on Nintendo
Switch and Switch 2.

**Port version:** 1.0.2<br>
**Targets:** Nintendo Switch and Switch 2. Online services are not available;
progress and supported features are stored locally.

This repository contains the wrapper source only. It does not contain the
game, its APK, or its assets.

## Install and prepare the game files

You need a legally obtained copy of **Jetpack Joyride 1.104.1** with the ARM64
native library and the matching **InstallPack** asset split. Other game
versions are not supported. The wrapper checks the version-specific file
sizes and rejects incomplete or mismatched files.

1. On your Android device, install the supported game version and its asset
   pack. Use a split-APK export tool to extract the installed package's
   **ARM64** split and **InstallPack** split. Do not use the ARM32 library.
2. From the ARM64 split, copy `lib/arm64-v8a/libmortargame.so`.
3. From the InstallPack split, copy `assets/assets.zip`.
4. On the SD card, create `/switch/jetpackjoyride_nx/` and place the files as
   shown below. Copy the built `jetpackjoyride_nx.nro` there too.

```text
sdmc:/switch/jetpackjoyride_nx/
├── jetpackjoyride_nx.nro
├── assets/
│   └── assets.zip
└── lib/
    └── arm64-v8a/
        └── libmortargame.so
```

The wrapper creates its `save/`, `cache/`, and `external/` directories on
launch. On first boot, it removes unused Android package files from this
folder and keeps the game library and `assets.zip`. Keep a backup of your
original extracted files if you also use them elsewhere.

## Launch

### Nintendo Switch

Launch the NRO through a title override (hold **R** while starting a game) so
the homebrew receives the full application memory pool and code-mapping
permissions. Album/applet mode is not supported.

### Nintendo Switch 2

Build with `SWITCH2=1` and launch the NRO through **kaiHEN hbloader**. The
Switch 2 build requires kaiHEN's `ldr:ro` service override for mapping the
game's ARM64 code. Album/applet mode is not supported.

## Controls

Controller mode is enabled by default. The on-screen cursor is hidden in this
mode; the game receives controller and D-pad input.

| Input | Action |
| --- | --- |
| D-pad / left stick | Navigate menus and move the character |
| A, B, X, Y | Game's corresponding controller buttons |
| L, R, ZR, L3, R3, + | Game's corresponding controller buttons |
| Minus (hold) | Touch the bottom-center of the screen; starts a run from the title screen |
| ZL | Toggle mouse/cursor mode |
| Left stick in mouse mode | Move the on-screen cursor |
| A or ZR in mouse mode | Click or hold the cursor |
| Touchscreen | Touch input in either mode |

When touch inputs overlap, the physical touchscreen takes priority over Minus,
which takes priority over the cursor click.

## Configuration

The first launch creates `sdmc:/switch/jetpackjoyride_nx/config.txt`. Edit it
while the game is closed. The render dimensions are read on launch; unsupported
values use the default 1280x720 output.

```text
# Render dimensions (width 640-1920, height 360-1080)
screen_width -1
screen_height -1

# Language: 0 follows the Switch system language, 1 Japanese, 2 English
language 0
```

## Build from source

Builds require the devkitPro AArch64 toolchain. The commands below assume a
Bash environment where devkitPro is available at `/opt/devkitpro`, as expected
by `build.sh`.

Clone this repository and enter its directory:

```bash
git clone https://github.com/NaGaa95/jetpackjoyride_nx.git
cd jetpackjoyride_nx
```

### Switch build

Install devkitPro's Switch development packages:

```bash
pacman -S switch-dev switch-mesa switch-libdrm_nouveau switch-sdl2 switch-zlib
```

From the repository root, build the NRO:

```bash
./build.sh clean
```

The `clean` argument removes old outputs and then builds. To rebuild
incrementally on later runs, use `./build.sh` instead.

### Switch 2 build

Install SDL2 from devkitPro, then install the
[ounce-devkit](https://github.com/ouncebrew/ounce-devkit) into the same
devkitPro installation. From the devkitPro MSYS2 shell:

```bash
pacman -S switch-sdl2
git clone https://github.com/ouncebrew/ounce-devkit.git
cd ounce-devkit
sh install.sh
```

Change back to the `jetpackjoyride_nx` repository folder, then build:

```bash
./build.sh clean SWITCH2=1
```

The `clean` argument removes old outputs and then builds. To rebuild
incrementally on later runs, use `./build.sh SWITCH2=1` instead.

The commands above build serially. To compile with four jobs in parallel,
append `-j4` to the build command; this is optional and uses more memory.

Both targets write `jetpackjoyride_nx.nro` in the repository root and share
their build directory. Run the corresponding clean command when switching
between Switch and Switch 2 builds. The generated NRO is ignored by Git; do
not commit it or any extracted game files.

### Optional desktop regression checks

The input and offline time-sync checks do not need the Switch SDK or game
files. With Python 3 and Clang installed, run:

```bash
python tests/run_regressions.py --cc clang
```

## Troubleshooting

- **Missing or unsupported game files:** confirm the ARM64 split contains
  `lib/arm64-v8a/libmortargame.so` and InstallPack contains
  `assets/assets.zip`. They must both be from version 1.104.1.
- **Switch 2 says code mapping is unavailable:** launch through kaiHEN
  hbloader with the `ldr:ro` override enabled.
- **Switch says a required syscall is unavailable or the app closes at once:**
  use a title override instead of Album/applet mode.
- **The game crashes during startup:** check
  `sdmc:/switch/jetpackjoyride_nx/boot.log` and, if present,
  `sdmc:/switch/jetpackjoyride_nx/fatal.txt`. Include both when reporting a
  reproducible issue.
- **Daily features show the wrong date while offline:** set the console clock
  accurately. The port uses the system clock for supported offline time-gated
  features.

## Credits

- TheOfficialFloW, Andy Nguyen, and fgsfds for the Android shared-object loader
  lineage
- devkitPro and libnx contributors for the Nintendo Switch homebrew toolchain
- Ouncebrew for Switch 2 support libraries and kaiHEN for `ldr:ro`
- Mesa and SDL contributors for graphics and audio support

## Legal

This project is not affiliated with Halfbrick Studios. Jetpack Joyride and all
related assets are trademarks or property of their respective owners. All
rights reserved. No assets or program code from Jetpack Joyride are included
in this repository. Users must provide their own legally obtained game files.
