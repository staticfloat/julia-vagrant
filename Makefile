ORIG_DIR=$(shell pwd)

.SECONDARY:

images/ubuntu%.iso:
	# Parse out version and arch, download appropriate .ISO
	# Note that some versions need minor versions added on to the end of them. :(
	VERSION_ARCH=$(subst .iso,,$(subst images/ubuntu,,$@)); \
	VERSION=$$(echo $$VERSION_ARCH | cut -d- -f1); \
	ARCH=$$(echo $$VERSION_ARCH | cut -d- -f2); \
	if [ "$$ARCH" == "x64" ]; then \
		UBUNTU_ARCH="amd64"; \
	else \
		UBUNTU_ARCH="i386"; \
	fi; \
	if [ "$$VERSION" == "14.04" ]; then \
		VERSION="14.04.1"; \
	fi; \
	if [ "$$VERSION" == "12.04" ]; then \
		VERSION="12.04.5"; \
	fi; \
	wget -q -O- http://releases.ubuntu.com/$$VERSION/MD5SUMS | grep ubuntu-$$VERSION-server-$$UBUNTU_ARCH.iso | cut -d' ' -f1 > $@.md5; \
	wget -c -O $@.tmp http://releases.ubuntu.com/$$VERSION/ubuntu-$$VERSION-server-$$UBUNTU_ARCH.iso; \
	mv $@.tmp $@

images/centos7.0-x64.iso:
	wget -q -O- http://mirrors.mit.edu/centos/7.0.1406/isos/x86_64/md5sum.txt | grep CentOS-7.0-1406-x86_64-NetInstall.iso | cut -d' ' -f1 > $@.md5
	wget -c -O $@.tmp http://mirrors.mit.edu/centos/7.0.1406/isos/x86_64/CentOS-7.0-1406-x86_64-NetInstall.iso
	mv $@.tmp $@

images/arch14.08-x64.iso:
	wget -q -O- http://mirrors.mit.edu/archlinux/iso/2014.08.01/md5sums.txt | grep archlinux-2014.08.01-dual.iso | cut -d' ' -f1 > $@.md5
	wget -c -O $@.tmp http://mirrors.mit.edu/archlinux/iso/2014.08.01/archlinux-2014.08.01-dual.iso
	mv $@.tmp $@


images/OSX_InstallESD_%.dmg:
	# Get version, look for source file, convert!
	VERSION=$$(echo $(subst images/OSX_InstallESD_,,$@) | cut -d_ -f1); \
	if [ ! -f images/OSX$$VERSION.* ]; then \
		echo "Unable to find images/OSX$$VERSION.*, you must provide OSX installer packages!"; \
		exit 1; \
	fi; \
	sudo images/prepare_iso.sh images/OSX$$VERSION.* images/
	md5 -q $@ > $@.md5


boxes/osx10.7.box: images/OSX_InstallESD_10.7_11A511.dmg
boxes/osx10.8.box: images/OSX_InstallESD_10.8_12A269.dmg
boxes/osx10.9.box: images/OSX_InstallESD_10.9.4_13E28.dmg
boxes/osx10.10.box: images/OSX_InstallESD_10.10_14A299l.dmg

define UBUNTU_ISO
boxes/ubuntu$(1).box: images/ubuntu$(1).iso
endef
$(foreach vers,12.04-x86 12.04-x64 14.04-x86 14.04-x64,$(eval $(call UBUNTU_ISO,$(vers))))

define CENTOS_ISO
boxes/centos$(1).box: images/centos$(1).iso
endef
$(foreach vers,7.0-x64,$(eval $(call CENTOS_ISO,$(vers))))

boxes/arch14.08-x64.box: images/arch14.08-x64.iso



# Put specific provisioning patterns first, so that we override the base boxes rule
boxes/buildmaster_%.box: boxes/%.box
	$(MAKE) provision-buildmaster_$(subst .box,,$(subst boxes/,,$^))
boxes/buildslave_%.box: boxes/%.box
	$(MAKE) provision-buildslave_$(subst .box,,$(subst boxes/,,$^))
boxes/juliadev_%.box: boxes/%.box
	$(MAKE) provision-juliadev_$(subst .box,,$(subst boxes/,,$^))
boxes/juliabox_%.box: boxes/%.box
	$(MAKE) provision-juliabox_$(subst .box,,$(subst boxes/,,$^))

# Rules to make base boxes
boxes/%.box:
	@# Check to make sure we actually support building this guy
	@if [ -z "$^" ]; then \
		echo "ERROR: Target $@ is invalid, did your enormous sausage fingers mistype?!"; \
		exit 1; \
	fi
	IMG=$^; \
	MD5=$$(cat $^.md5); \
	NAME=$(subst .box,,$(subst boxes/,,$@)); \
	TEMPLATE=$$(echo $$NAME | sed -e 's/[0-9]/#/g' | cut -d# -f1 ); \
	if [ "$$TEMPLATE" = "osx" ]; then \
		OS_TYPE=darwin$$(($$(echo $$NAME | cut -c7-)+4))-64; \
	fi; \
	rm -rf output-$$NAME; \
	packer build -var md5=$$MD5 -var img=$$IMG -var name=$$NAME -var os_type=$$OS_TYPE $$TEMPLATE.packer; \
	rm -rf packer_cache;

# Rules for provisioning base boxes into something we'd have dinner with
provision-%:
	TEMPLATE_BOX=$(subst provision-,,$@); \
	TEMPLATE=$$(echo $$TEMPLATE_BOX | sed -e 's/[0-9]/#/g' | cut -d# -f1 ); \
	BOX=$$(echo $$TEMPLATE_BOX | cut -d_ -f2); \
	vagrant box remove -f $$BOX; \
	vagrant box add $$BOX boxes/$$BOX.box; \
	rm -rf /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	mkdir -p /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	cd /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	vagrant init $$BOX; \
	rm Vagrantfile; \
	cp -f $(ORIG_DIR)/$$TEMPLATE.provision Vagrantfile; \
	sed -i .bak -e "s/BOX_NAME/$$BOX/g" Vagrantfile; \
	rm Vagrantfile.bak; \
	cp -f -R $(ORIG_DIR)/support .; \
	vagrant up; \
	vagrant halt; \
	cd $$(dirname $$(find . -name disk.vmdk)); \
	qemu-img convert -p -f vmdk -O qcow2 disk.vmdk $(ORIG_DIR)/openstack/$$TEMPLATE_BOX.qcow2; \
	tar cvzf $(ORIG_DIR)/boxes/$$TEMPLATE_BOX.box ./*; \
	cd /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	vagrant destroy -f;



# This is pretty aggressive.  Oh well.
clean:
	rm -f boxes/*.box openstack/*.qcow2


