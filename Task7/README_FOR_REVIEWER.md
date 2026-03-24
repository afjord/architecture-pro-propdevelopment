Директория [verify](verify) содержит два файла которые проверяют корректность работы манифестов в директориях [insecure-manifests](insecure-manifests) и [secure-manifests](secure-manifests).

Как запускать:
```shell
chmod +x verify/verify-admission.sh verify/validate-security.sh \
./verify/verify-admission.sh
./verify/validate-security.sh
```