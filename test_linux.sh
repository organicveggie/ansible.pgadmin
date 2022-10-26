#!/bin/sh

tox -- test --platform-name lxd-instance --driver-name lxd "$@"
