ROOTDIR = rootdir
IMG     = takao.img

QEMU      = qemu-system-x86_64
QEMUFLAGS = -enable-kvm -cpu host \
	-m 4G                         \
	-bios OVMF.fd                 \
	-drive file=$(IMG),media=disk,format=raw

IMAGEBUILDERGIT = https://github.com/TomatOrg/image-builder
IMAGEBUILDER    = image-builder
TOMATBOOTGIT    = https://github.com/TomatOrg/TomatBoot-UEFI
TOMATBOOT       = TomatBoot-UEFI
TAKAOGIT        = https://github.com/Takao-OS/Takao
TAKAO           = Takao
OVMFURL         = http://downloads.sourceforge.net/project/edk2/OVMF/OVMF-X64-r15214.zip
OVMF            = OVMF-X64-r15214.zip
OVMFFD          = OVMF.fd

all: prepare boot kernel image-builder img ovmf test

prepare:
	mkdir $(ROOTDIR)
	git clone $(IMAGEBUILDERGIT)
	git clone $(TOMATBOOTGIT)
	git clone $(TAKAOGIT)
	cd $(TAKAO) && git checkout development

boot:
	cd $(TOMATBOOT) && $(MAKE) CLANG=clang
	mkdir -pv $(ROOTDIR)/EFI/BOOT/
	mv $(TOMATBOOT)/bin/BOOTX64.EFI $(ROOTDIR)/EFI/BOOT/
	cp tomatboot.cfg $(ROOTDIR)/EFI/

kernel:
	cd $(TAKAO) && ./configure && make
	cp $(TAKAO)/takao.elf $(ROOTDIR)/EFI/

img:
	python3 $(IMAGEBUILDER)/image-builder.py image.yaml

clean:
	rm -rf $(ROOTDIR)
	rm -rf $(IMAGEBUILDER)
	rm -rf $(TOMATBOOT)
	rm -rf $(TAKAO)
	rm -rf $(OVMFFD)
	rm -rf $(IMG)

ovmf:
	wget $(OVMFURL)
	unzip $(OVMF) $(OVMFFD)
	rm -r $(OVMF)

test: ovmf
	$(QEMU) $(QEMUFLAGS)
