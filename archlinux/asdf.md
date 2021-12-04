# ASDF

## Descrition

Manage multiple runtime versions with a single CLI tool, extendable via plugins.

## References

- [Official ASDF website](https://asdf-vm.com/)

- [Official ASDF repository](https://github.com/asdf-vm/asdf)

- [Official ASDF plugin NodeJS repository](https://github.com/asdf-vm/asdf-nodejs)

- [Tutorial ASDF and Python Plugin](https://cloudolife.com/2020/10/10/Programming-Language/Python/Installation/Use-asdf-python-plugin-to-install-multiple-Python-versions/)

## Installation setup

### Dependencies

### Software

- ASDF

```bash
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1
echo ". $HOME/.asdf/asdf.sh" >> $HOME/.bashrc
echo ". $HOME/.asdf/completions/asdf.bash" >> $HOME/.bashrc
```

### Plugins

- NodeJS

```bash
#Install NodeJS plugin
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

#List all NodeJS plugins available
asdf list all nodejs

#Install NodeJS versions
asdf install nodejs latest
asdf install nodejs lts

#Set NodeJS environment
asdf global nodejs lts
#asdf local nodejs latest #Your current working directory

#Check if NodeJS version
nodejs --version
```

- Python

```bash
#Install Python plugin
asdf plugin-add python
asdf plugin update python
 
#List all Python plugins available
asdf list all python

#Install Python versions
>>>>--->>>>
asdf install python 3.6-dev
asdf install python 3.6.0
asdf install python 3.9.2

#Set Python environment
asdf global python 3.9.2
cd ~/Documents/voice_assistant_linux/ && asdf local python 3.6-dev #Your current working directory

#Check if Python version
python --version
```