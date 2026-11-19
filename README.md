# genlimineconf

Utility program and kernel hooks for updating [Limine Bootloader](https://github.com/Limine-Bootloader/Limine) configuration
after every kernel update by `xbps-reconfigure` in Void Linux (refer [this](https://docs.voidlinux.org/config/kernel.html)).

> Inspired by [Zesko/limine-entry-tool](https://gitlab.com/Zesko/limine-entry-tool); written in bash because I don't like Java

## Usage

On first install, run:

```bash
genlimineconf generate
```

After that, `/etc/kernel.d/post-install` and `/etc/kernel.d/post-remove`
run the command automatically every time the kernels are updated by XBPS.

Note: `generate` always backs up the existing `limine.conf` to `limine.conf.bak`
before writing, and restores it automatically if generation fails.

Custom Limine options can be added by dropping `.conf` files into
`/etc/genlimineconf/limine.conf.d`; `genlimineconf generate` concatenates every file there,
in lexical order, directly into the top of the generated `limine.conf`.

Note: Some default options are provided in `/etc/genlimineconf/limine.conf.d/options.conf`.

## Commands

| Command | Args | Required env | Output |
|---|---|---|---|
| `generate` | - | - | Scans `/boot` for kernels already present, and `/etc/genlimineconf/limine.conf.d` for user-defined Limine options to generate and replace the existing `limine.conf`. |
| `refresh` | - | `$ENTRIESDIR` - must already exist | Deletes every `*.entry` file in `$ENTRIESDIR`, then scans `/boot` for `vmlinuz-*` and recreates an entry for each version via `add-entry`. |
| `add-entry` | `<pkgname> <version>` | `$ENTRIESDIR` - must already exist | Writes `$ENTRIESDIR/<pkgname>_<version>.entry`, pointing at `/boot/vmlinuz-<version>` and `/boot/initramfs-<version>.img`. |
| `remove-entry` | `<pkgname> <version>` | `$ENTRIESDIR` - must already exist | Deletes `$ENTRIESDIR/<pkgname>_<version>.entry` if it exists; errors out if it doesn't. |

## Build

```bash
make            # builds dist/ - see Makefile for overridable build-time variables (PREFIX, KERNEL_NAME, etc.)
make install    # installs dist/ onto the system (DESTDIR supported); does not touch already present user-defined `.conf` files
make uninstall  # removes installed files, except the user-defined files
make clean      # removes dist/
```

| Target | Depends on | Effect |
|---|---|---|
| `all` (default) | - | Builds every artifact into `dist/`: the `genlimineconf` binary, `lib/`, all the subcommands in `cmd/`, both kernel hooks and `options.conf` - all substituted with the current build-time variables. Idempotent; only rebuilds what changed. |
| `clean` | - | `rm -rf dist`. |
| `install` | `all` | Copies `dist/` onto `$(DESTDIR)/` (or `/` if `DESTDIR` unset). Does not touch `$(DESTDIR)$(CONFDIR)`, if already present. |
| `uninstall` | - | Removes installed files and dirs. Does not touch `$(DESTDIR)$(CONFDIR)`. |

## Testing

`src/**/*.sh` are build templates, not runnable scripts - they contain
literal `@VARNAME@` placeholders substituted by `make`. Sourcing them
directly from `src/` gives you variables whose value is the literal string
`@VARNAME@`, not a real path.

Run `make all` first, then source/test against the compiled output instead.

Example:
```bash
make all
source dist/usr/libexec/genlimineconf/lib/00-core.sh
get_root_part_uuid
```
