#!/bin/sh

PY_COLORS=1
ANSIBLE_FORCE_COLOR=1

tox -- test --driver-name vagrant --platform-name vagrant-instance "$@"
