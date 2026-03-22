#!/usr/bin/env bash
set -u

NAMESPACE="development"

PASS_COUNT=0
FAIL_COUNT=0

check_access() {
  local from_pod="$1"
  local to_service="$2"
  local expected="$3" # allow | deny

  echo "==> Проверка: ${from_pod} -> ${to_service} (ожидается: ${expected})"

  if kubectl exec -n "${NAMESPACE}" "${from_pod}" -- sh -c \
    "curl -m 2 -sSf http://${to_service} >/dev/null 2>&1"
  then
    actual="allow"
  else
    actual="deny"
  fi

  if [[ "${actual}" == "${expected}" ]]; then
    echo "   [OK] Фактический результат: ${actual}"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "   [FAIL] Фактический результат: ${actual}, ожидалось: ${expected}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  echo
}

echo "Проверяем доступность сервисов в namespace: ${NAMESPACE}"
echo

check_access "front-end-app" "back-end-api-app" "allow"
check_access "back-end-api-app" "front-end-app" "allow"
check_access "admin-front-end-app" "admin-back-end-api-app" "allow"
check_access "admin-back-end-api-app" "admin-front-end-app" "allow"

check_access "front-end-app" "admin-front-end-app" "deny"
check_access "front-end-app" "admin-back-end-api-app" "deny"

check_access "back-end-api-app" "admin-front-end-app" "deny"
check_access "back-end-api-app" "admin-back-end-api-app" "deny"

check_access "admin-front-end-app" "front-end-app" "deny"
check_access "admin-front-end-app" "back-end-api-app" "deny"

check_access "admin-back-end-api-app" "front-end-app" "deny"
check_access "admin-back-end-api-app" "back-end-api-app" "deny"

echo "========================================"
echo "Успешно: ${PASS_COUNT}"
echo "Провалено: ${FAIL_COUNT}"
echo "========================================"

if [[ "${FAIL_COUNT}" -gt 0 ]]; then
  exit 1
fi