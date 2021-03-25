# Takao-OS's build system.

![Banner](banner.png)

This is the repository for the build scripts of the final distribution of
Takao and not only the kernel.

For making the distribution and image you will need `xbstrap`.

For building:

```bash
mkdir build && cd build && xbstrap init .. && xbstrap install --all
```

And to generate the final disk image:

```bash
./makeimage.sh
```
