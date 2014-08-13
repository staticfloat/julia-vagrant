ORIG_DIR=$(shell pwd)

images/ubuntu%.iso:
	# Parse out version and arch, download appropriate .ISO
	VERSION_ARCH=$(subst .iso,,$(subst images/ubuntu,,$@)); \
	VERSION=$$(echo $$VERSION_ARCH | cut -d- -f1); \
	ARCH=$$(echo $$VERSION_ARCH | cut -d- -f2); \
	if [ "$$ARCH" == "x64" ]; then \
		UBUNTU_ARCH="amd64"; \
	else \
		UBUNTU_ARCH="i386"; \
	fi; \
	wget -q -O- http://releases.ubuntu.com/$$VERSION/MD5SUMS | grep ubuntu-$$VERSION-server-$$UBUNTU_ARCH.iso | cut -d' ' -f1 > $@.md5; \
	wget -c -O $@.tmp http://releases.ubuntu.com/$$VERSION/ubuntu-$$VERSION-server-$$UBUNTU_ARCH.iso; \
	mv $@.tmp $@

# Rules to make base ubuntu boxes
boxes/ubuntu%.box: images/ubuntu%.iso
	IMG=$^; \
	MD5=$$(cat $^.md5); \
	NAME=$(subst .box,,$(subst boxes/,,$@)); \
	rm -rf output-$$NAME; \
	packer build -var md5=$$MD5 -var img=$$IMG -var name=$$NAME ubuntu.packer; \
	rm -rf packer_cache


# Rules for provisioning base ubuntu boxes into something we'd have dinner with
provision-%:
	TEMPLATE_BOX=$(subst provision-,,$@); \
	TEMPLATE=$$(echo $$TEMPLATE_BOX | cut -d_ -f1); \
	BOX=$$(echo $$TEMPLATE_BOX | cut -d_ -f2); \
	vagrant box remove -f $$BOX; \
	vagrant box add $$BOX boxes/$$BOX.box; \
	rm -rf /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	mkdir -p /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	cd /tmp/julia-vagrant/$$TEMPLATE_BOX; \
	vagrant init $$BOX; \
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


boxes/buildmaster_%.box: boxes/%.box
	$(MAKE) provision-buildmaster_$(subst .box,,$(subst boxes/,,$^))

boxes/buildslave_%.box: boxes/%.box
	$(MAKE) provision-buildslave_$(subst .box,,$(subst boxes/,,$^))


# Build our buildmaster out of ubuntu14.04.1-x64
buildmaster: boxes/buildmaster_ubuntu14.04.1-x64.box

buildslave_ubuntu14.04.1-x64: boxes/buildslave_ubuntu14.04.1-x64.box
buildslave_ubuntu14.04.1-x86: boxes/buildslave_ubuntu14.04.1-x86.box


clean:
	rm -f boxes/*.box openstack/*.qcow2
