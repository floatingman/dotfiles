# My Dotfiles
These are my dotfiles. I use [RCM](https://thoughtbot.github.io/rcm) to manage them.

## Installing
With RCM, you can initially link files with `rcup -x "README.md *zsh\*`

This will link all of the files but this readme and the zsh configuration directory, which doesn't need to be linked.

Afterwords, those things will be excluded, by using the [rcrc](../main/rcrc) file, so you just have to run `rcup`

## Tagging
RCM has a concept of tagging certain config files. These files can be linked with `rcup -t <TAG>`. The only tag I'm using currently is for my linux gui app. You can link these with `rcup -t linux-gui`
