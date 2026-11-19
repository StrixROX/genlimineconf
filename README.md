# genlimineconf

Utility program and kernel hooks for updating Limine Bootloader configuration
after every kernel update by `xbps-reconfigure` in Void Linux.

## Usage

On first install, run:

```
genlimineconf refresh
genlimineconf generate
```

`refresh` scans `/boot` for kernels already present and (re)creates their
boot entries; `generate` then writes those entries into `limine.conf`.
After that, `/etc/kernel.d/post-install` and `/etc/kernel.d/post-remove`
hooks keep entries in sync automatically on every kernel
install/remove via `xbps-reconfigure` — no manual steps needed.

Note: `generate` always backs up the existing `limine.conf` to `limine.conf.bak`
before writing, and restores it automatically if generation fails.

Custom Limine options are added by dropping `.conf` files into
`$CONFDIR_PATH/$CONFDIR_NAME` — `generate` concatenates every file there,
in lexical order, directly into the top of the generated `limine.conf`.

Note: `options.conf` (the default file dropped there at install time) is
removed by `make uninstall`. Put your own customizations in a **new**
`.conf` file in that directory instead of editing `options.conf` directly,
or they'll be deleted on uninstall.

## Commands

| Command | Args | Effect on disk |
|---|---|---|
| `add-entry` | `<pkgname> <version>` | Writes `$ENTRIESDIR_PATH/$ENTRIESDIR_NAME/<pkgname>_<version>.entry`, pointing at `/boot/$KERNEL_PATH/vmlinuz-<version>` and `initramfs-<version>.img`. |
| `remove-entry` | `<pkgname> <version>` | Deletes `$ENTRIESDIR_PATH/$ENTRIESDIR_NAME/<pkgname>_<version>.entry` if it exists. |
| `refresh` | — | Deletes all `*.entry` files in `$ENTRIESDIR_PATH/$ENTRIESDIR_NAME`, then scans `/boot/$KERNEL_PATH` for `vmlinuz-*` and re-creates an entry for each via `add-entry`. Does **not** regenerate `limine.conf` — run `generate` after. |
| `generate` | — | Backs up the current `limine.conf` to `limine.conf.bak`, then rewrites it from `$CONFDIR_PATH/$CONFDIR_NAME/*.conf` (user options) plus every `*.entry` file, newest first. Restores the backup automatically if generation fails. |

## Build

```
make            # same as `make all`
make all        # builds dist/ — see Makefile for overridable build-time variables (PREFIX, KERNEL_NAME, etc.)
make install    # installs dist/ onto the system (DESTDIR supported)
make uninstall  # removes installed files; force-wipes entries/
make clean      # removes dist/
```

| Target | Depends on | Effect |
|---|---|---|
| `all` (default) | — | Builds every artifact into `dist/`: the `genlimineconf` binary, `lib/`, every subcommand, both kernel hooks, `options.conf`, and an empty entries dir — all substituted with the current build-time variables. Idempotent; only rebuilds what changed. |
| `clean` | — | `rm -rf dist`. |
| `install` | `all` | Copies `dist/` onto `$(DESTDIR)/` (or `/` if `DESTDIR` unset). |
| `uninstall` | `all` | Rebuilds `dist/` to know the current file list, removes every file it would have installed, force-deletes the entries dir regardless of contents, then prunes any directories left empty (so directories still holding user `.conf` files survive). |
