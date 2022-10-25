#!/bin/sh

echo virtualenv venv
virtualenv venv
. venv/bin/activate

echo pip install --upgrade pip
pip install --upgrade pip

echo pip install ansible molecule "ansible-lint" "molecule[docker]" "molecule-lxd" "molecule[lxd]"
pip install ansible molecule "ansible-lint" "molecule[docker]" "molecule-lxd" "molecule[lxd]"