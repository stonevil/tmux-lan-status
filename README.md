# Tmux LAN status

Tmux plugin that enables displaying LAN status and IP for your workstation.

Inspider by [https://github.com/tmux-plugins/tmux-online-status](https://github.com/tmux-plugins/tmux-online-status)

Introduces a new `#{lan_status}` format.

This plugin is useful if:
- you spend most of your time in Tmux and don't want to "switch" away from the terminal to check whether you're connected.

### Usage

Add `#{lan_status}` format string to your existing `status-left` tmux option.


Here's the example in `.tmux.conf`:

    set -g status-left "#{lan_status} "

#### Configure icons
If the icons don't display well on your machine you can change them in
`.tmux.conf`:

    set -g @lan_icon "ok"

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins "                 \
      tmux-plugins/tpm                    \
      stonevil/tmux-lan-status            \
    "

Hit `prefix + I` to fetch the plugin and source it.

`#{lan_status}` interpolation should now work.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/stonevil/tmux-lan-status ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/lan_status.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

`#{lan_status}` interpolation should now work.

### Limitations

LAN status icon most likely won't be instant. The duration depends on the `status-interval` Tmux option. So, it might take anywhere between 5 and 60 seconds for LAN status icon to change.

Set `status-interval` to a low number to make this faster, example:

    # in .tmux.conf
    set -g status-interval 5

### Other plugins

You might also find these useful:

- [wan-status](https://github.com/stonevil/tmux-wan-status) - WAN status and IP
- [vm-status](https://github.com/stonevil/tmux-vm-status) - started Virtual Machines status

### License

[MIT](LICENSE.md)
