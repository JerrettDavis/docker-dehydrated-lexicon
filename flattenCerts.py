from pathlib import Path

#copies certs and keys to root cert directory

certsDir = Path("/") / "dehydrated/certs"
certName = "fullchain.pem"
keyName = "privkey.pem"
for domain in certsDir.iterdir():
    if not domain.is_dir():
        continue
    src_key = certsDir / domain.name / keyName
    dest_key = certsDir / f"{domain.name}.key"

    if not dest_key.exists() and src_key.exists():
        dest_key.write_bytes(src_key.read_bytes())

    src_cert = certsDir / domain.name / certName
    dest_cert = certsDir / f"{domain.name}.crt"

    if not dest_cert.exists() and src_cert.exists():
        dest_cert.write_bytes(src_cert.read_bytes())