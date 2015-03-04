#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

lan_option_string="@lan_icon"

lan_icon_osx="ⓛ "
lan_icon="LAN IP "

lan_icon_default() {
	if is_osx; then
		echo "$lan_icon_osx"
	else
		echo "$lan_icon"
	fi
}

ip_lan_status() {
	if is_osx; then
		ALL_NICS=$(ifconfig 2>/dev/null | awk -F':' '/^[a-z]/ && !/^lo/ { print $1 }')
		for NIC in ${ALL_NICS[@]}; do
			IPV4S_ON_NIC=$(ifconfig ${NIC} 2>/dev/null | awk '$1 == "inet" { print $2 }')
			for IPLAN in ${IPV4S_ON_NIC[@]}; do
				[[ -n "${IPLAN}" ]] && break
			done
			[[ -n "${IPLAN}" ]] && break
		done
  fi

	if is_linux; then
		# Get the names of all attached NICs.
		ALL_NICS="$(ip addr show | cut -d ' ' -f2 | tr -d :)"
		ALL_NICS=(${ALL_NICS[@]//lo/})	 # Remove lo interface.

		for NIC in "${ALL_NICS[@]}"; do
			# Parse IP address for the NIC.
			IPLAN="$(ip addr show ${NIC} | grep '\<inet\>' | tr -s ' ' | cut -d ' ' -f3)"
			# Trim the CIDR suffix.
			IPLAN="${IPLAN%/*}"
			# Only display the last entry
			IPLAN="$(echo "$IPLAN" | tail -1)"
			[ -n "$IPLAN" ] && break
		done
	fi

  echo "$IPLAN"
}

print_lan_status() {
	# spacer fixes weird emoji spacing
	local spacer=" "
  printf "$(get_tmux_option "$lan_option_string" "$(lan_icon_default)")$spacer$(ip_lan_status)"
}

main() {
  print_lan_status
}
main
