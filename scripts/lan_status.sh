#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

online_lan_option_string="@online_lan_icon"
offline_lan_option_string="@offline_lan_icon"

online_lan_icon_osx="ⓛ "
online_lan_icon="LAN IP "
offline_lan_icon_osx="⨂ "
offline_lan_icon="NO LAN IP "

online_lan_icon_default() {
	if is_osx; then
		echo "$online_lan_icon_osx"
	else
		echo "$online_lan_icon"
	fi
}

offline_lan_icon_default() {
	if is_osx; then
		echo "$offline_lan_icon_osx"
	else
		echo "$offline_lan_icon"
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
  if [ $(ip_lan_status) ]; then
    printf "$(get_tmux_option "$online_lan_option_string" "$(online_lan_icon_default)")$spacer$(ip_lan_status)"
  else
    printf "$(get_tmux_option "$offline_lan_option_string" "$(offline_lan_icon_default)")$spacer"
  fi
}

main() {
  print_lan_status
}
main
