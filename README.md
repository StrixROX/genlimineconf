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

`generate` always backs up the existing `limine.conf` to `limine.conf.bak`
before writing, and restores it automatically if generation fails.

Custom Limine options are added by dropping `.conf` files into
`$CONFDIR_PATH/$CONFDIR_NAME` — `generate` concatenates every file there,
in lexical order, directly into the top of the generated `limine.conf`.

## Commands

| Command | Args | Effect on disk |
|---|---|---|
| `add-entry` | `<pkgname> <version>` | Writes `$ENTRIESDIR_PATH/$ENTRIESDIR_NAME/<pkgname>_<version>.entry`, pointing at `/boot/$KERNEL_PATH/vmlinuz-<version>` and `initramfs-<version>.img`. |
| `remove-entry` | `<pkgname> <version>` | Deletes `$ENTRIESDIR_PATH/$ENTRIESDIR_NAME/<pkgname>_<version>.entry` if it exists. |
| `refresh` | — | Deletes all `*.entry` files in `$ENTRIESDIR_PATH/$ENTRIESDIR_NAME`, then scans `/boot/$KERNEL_PATH` for `vmlinuz-*` and re-creates an entry for each via `add-entry`. Does **not** regenerate `limine.conf` — run `generate` after. |
| `generate` | — | Backs up the current `limine.conf` to `limine.conf.bak`, then rewrites it from `$CONFDIR_PATH/$CONFDIR_NAME/*.conf` (user options) plus every `*.entry` file, newest first. Restores the backup automatically if generation fails. |

## Build

```
make all         # builds dist/ — see Makefile for overridable build-time variables (PREFIX, KERNEL_NAME, etc.)
make install     # installs dist/ onto the system (DESTDIR supported)
make uninstall   # removes installed files; force-wipes entries/
```
