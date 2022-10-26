#!/bin/sh

tox -- test --driver-name vagrant --platform-name vagrant-instance "$@"
