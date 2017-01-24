# Related project
- rendezvous-hub (server-side) https://github.com/keiya/rendezvous-hub
- apsisvpn (client side) https://github.com/keiya/apsisvpn

# Prerequisites
- `pip install docker`

# How to run
## busybox bash
- `docker build -f Dockerfile.busybox .`
- `python apsis.py busybox /bin/sh`

## firefox with x11
- `docker build -f Dockerfile.firefox .`
- `python apsis.py firefox firefox`
