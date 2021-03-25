# Takao-OS's build system.

![Banner](banner.png)

This is the repository for the build scripts of the final distribution of
Takao and not only the kernel.

## Dependencies

For making the distribution and image you will need `xbstrap`, which can be obtained with `pip` doing

```bash
pip install xbstrap
```

## Building

For building:

```bash
mkdir build && cd build && xbstrap init .. && xbstrap install --all
```

And to generate the final disk image:

```bash
./makeimage.sh
```
