#!/usr/bin/env python3
"""Block adware / tracking domains by rewriting /etc/hosts from a blocklist."""

import os
import socket
import sys
import urllib.request

BLOCKLIST_URL = "https://hblock.molinero.dev/hosts"
HOSTS_FILE = os.environ.get("HOSTS_FILE", "/etc/hosts")

def base_hosts():
    """The standard local entries, with the real hostname filled in."""
    hostname = socket.gethostname()
    return f"""\
127.0.0.1 localhost
127.0.1.1 {hostname}

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
"""


def fetch_blocked_lines(url):
    """Download the blocklist and keep only the '0.0.0.0 <domain>' lines."""
    req = urllib.request.Request(url, headers={"User-Agent": "Scripts"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        text = resp.read().decode("utf-8", errors="replace")
    return [line for line in text.splitlines() if line.startswith("0.0.0.0 ")]


def main():
    try:
        blocked = fetch_blocked_lines(BLOCKLIST_URL)
    except Exception as e:
        print(f"Error downloading blocklist: {e}")
        return 1

    if not blocked:
        print("No blocked hosts found in the list; leaving hosts file unchanged.")
        return 1

    content = base_hosts() + "\n" + "\n".join(blocked) + "\n"
    print(f"{len(blocked)} blocked hosts prepared.")

    # Back up the existing file and then write.
    try:
        if os.path.exists(HOSTS_FILE):
            backup = HOSTS_FILE + ".backup"
            if not os.path.exists(backup):
                with open(HOSTS_FILE) as src, open(backup, "w") as dst:
                    dst.write(src.read())
                print(f"Backed up {HOSTS_FILE} -> {backup}")

        tmp = HOSTS_FILE + ".tmp"
        with open(tmp, "w") as f:
            f.write(content)
        os.replace(tmp, HOSTS_FILE)
        print(f"Updated {HOSTS_FILE} with {len(blocked)} blocked hosts.")
    except PermissionError:
        print("Permission denied. Run with sudo.")
        return 1
    except Exception as e:
        print(f"Error writing hosts file: {e}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
