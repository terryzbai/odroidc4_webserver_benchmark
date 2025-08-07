
LIBNFS := libnfs
BUILD_DIR := build
TOOL_DIR=$(abspath .)

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/%_rootfs.cpio.gz: $(TOOL_DIR)/%_rootfs.cpio.gz $(BUILD_DIR)
	$(TOOL_DIR)/packrootfs $< $(BUILD_DIR)/rootfs -o $@ \
	    --home $(TOOL_DIR)/init_script $(TOOL_DIR)/cpu.jpg $(TOOL_DIR)/webserver

$(BUILD_DIR)/%_initramfs.img: $(BUILD_DIR)/%_rootfs.cpio.gz
	mkimage -A arm -O linux -T ramdisk -n "Initial Ram Disk" -d $< $@

qemu: $(BUILD_DIR)/qemu_rootfs.cpio.gz
	qemu-system-aarch64 -machine virt,gic-version=3,iommu=smmuv3 -cpu cortex-a53 \
        -nographic \
        -kernel linux_image \
        -initrd $< \
        -serial mon:stdio \
        -netdev user,id=net0,hostfwd=udp::80-:80,hostfwd=tcp::80-:80 \
        -device virtio-net-pci,netdev=net0,mac=52:54:00:12:34:56 \
        -m 1024

odroidc4: $(BUILD_DIR)/odroidc4_initramfs.img

all:

clean:
	rm -rf $(BUILD_DIR)
