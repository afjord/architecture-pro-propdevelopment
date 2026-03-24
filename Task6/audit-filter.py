import json

INPUT_FILE = "audit.log"
OUTPUT_FILE = "audit-extract.json"

suspicious = []

with open(INPUT_FILE) as f:
    for line in f:
        try:
            event = json.loads(line)
        except:
            continue

        user = event.get("user", {}).get("username")
        verb = event.get("verb")
        ref = event.get("objectRef", {})
        uri = event.get("requestURI", "")

        # secrets access
        if ref.get("resource") == "secrets":
            suspicious.append(event)

        # exec into pod
        if ref.get("subresource") == "exec":
            suspicious.append(event)

        # privileged pod
        try:
            containers = event["requestObject"]["spec"]["containers"]
            for c in containers:
                if c.get("securityContext", {}).get("privileged") is True:
                    suspicious.append(event)
        except:
            pass

        # rolebinding / clusterrolebinding
        if ref.get("resource") in ["rolebindings", "clusterrolebindings"]:
            suspicious.append(event)

        # audit policy modification
        if "audit-policy" in uri:
            suspicious.append(event)

with open(OUTPUT_FILE, "w") as f:
    json.dump(suspicious, f, indent=2)

print(f"Extracted {len(suspicious)} suspicious events")