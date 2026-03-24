### Проверка пунктов 1-4 осуществляется следующим образом:

Директория [verify](verify) содержит два файла которые проверяют корректность работы манифестов в
директориях [insecure-manifests](insecure-manifests) и [secure-manifests](secure-manifests).

Как запускать:

```shell
chmod +x verify/verify-admission.sh verify/validate-security.sh \
./verify/verify-admission.sh
./verify/validate-security.sh
```

### Проверка пункта 5 осуществляется следующим образом:

1. Установка Gatekeeper:
   ```shell
   kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.22.0/deploy/gatekeeper.yaml
   ```
2. Применение манифестов Gatekeeper:
   ```shell
   kubectl apply -f gatekeeper/constraint-templates
   kubectl apply -f gatekeeper/constraints
   ```
3. Создание `namespace` и тестирование правил:
   ```shell
   kubectl create namespace gatekeeper-test
   kubectl apply -f gatekeeper/verify/bad-pod.yaml
   kubectl apply -f gatekeeper/verify/safe-pod.yaml
   ```
   В результате применения `bad-pod.yaml` под не должен быть создан, т.к. он нарушает заданные правила.
   В результате применения `safe-pod.yaml` под должен быть создан, т.к. он не нарушает заданные правила.
