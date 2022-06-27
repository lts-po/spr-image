
process:
* import img to docker
* build from imported image
* export built container

```sh
mod-docker/import-docker.sh
cd mod-docker; build-docker.sh; cd ..
mod-docker/export-docker.sh
```

*NOTE* *TODO*
copy over kernel if updated

cp fs/boot/{initrd.img,vmlinuz} boot
