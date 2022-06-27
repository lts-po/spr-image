
process:
* import img to docker
* build from imported image
* export built container

```sh
./import-docker.sh
./build-docker.sh
./export-docker.sh
```

*NOTE* *TODO*
copy over kernel if updated

cp fs/boot/{initrd.img,vmlinuz} boot
