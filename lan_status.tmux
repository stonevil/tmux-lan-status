#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/scripts/helpers.sh

lan_status="#($CURRENT_DIR/scripts/lan_status.sh)"
lan_status_interpolation_string="\#{lan_status}"

do_interpolation() {
	local string=$1
	local interpolated=${string/$lan_status_interpolation_string/$lan_status}
	echo "$interpolated"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
