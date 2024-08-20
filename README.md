# asdf-pug

[pug](https://github.com/leg100/pug) plugin for the [asdf version manager](https://asdf-vm.com).

## Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

## Dependencies

- `bash`, `curl`, `unzip`: generic POSIX utilities.

## Install

Plugin:

```shell
asdf plugin add pug https://github.com/zonk1/asdf-pug.git
```

pug:

```shell
# Show all installable versions
asdf list-all pug

# Install specific version
asdf install pug latest

# Set a version globally (on your ~/.tool-versions file)
asdf global pug latest

# Now pug commands are available
pug --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/zonk1/asdf-pug/graphs/contributors)!

## License

See [LICENSE](LICENSE) © [zonk1](https://github.com/zonk1/)

## Thanks

[aider-chat](https://github.com/paul-gauthier/aider/) wrote most of this project.
