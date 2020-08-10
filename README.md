# meta-avnet
Yocto layer that can be added on top of a Petalinux Project to add:
- Avnet Machine Configurations: 'ultra96v2'
- Avnet Tools and Programs
- Avnet image (avnet-image-minimal) to include extra packages for Avnet boards' rootfs.

To use it: 
- clone this repository in the project-spec/ folder inside your Petalinux project
- in Petalinux config, 'Yocto Settings'/'User Layers', add a new layer with '${PROOT}/project-spec/meta-avnet'
- in Petalinux config, change the YOCTO_MACHINE_NAME to use an Avnet Machine ('ultra96v2' for example)
- then you can use 'petalinux-build -c avnet-image-minimal' to build your BSP
