#!/bin/sh

PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
PATH="$PYENV_ROOT/shims:${PATH}"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pversion=`pyenv latest 3`
echo "Latest pyenv Python version is $pversion"

venv="ansible-$pversion"
echo "pyenv virtualenv $pversion $venv"
pyenv virtualenv ${pversion} ${venv}

pyenv activate ${venv}
pyenv local ${venv}

echo "pip install --upgrade pip"
pip install --upgrade pip

echo "pip install ansible ansible-navigator ansible-lint argcomplete"
pip install ansible ansible-navigator ansible-lint argcomplete

echo "pip install molecule molecule-vagrant molecule-lxd tox"
pip install molecule molecule-vagrant molecule-lxd tox
