

## usage

```
dhcp; tftpboot 0x40000000 /odroidc4-terryb/nginx_benchmark/Image; tftpboot 0x5f000000 /odroidc4-terryb/nginx_benchmark/linux.dtb; tftpboot 0x4c000000 /odroidc4-terryb/nginx_benchmark/initramfs.img; setenv bootargs "console=ttyAML0,115200 rootfstype=ext4 root=/dev/mmcblk0p2 rw rootwait debug"; booti 0x40000000 0x4c000000 0x5f000000
```
