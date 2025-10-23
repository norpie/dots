#!/usr/bin/env bash

# Path to hyprsunset config
HYPRSUNSET_CONFIG="$HOME/.config/hypr/hyprsunset.conf"

# Function to parse hyprsunset.conf and get settings for current time
get_settings_for_time() {
    local hour=$(date +%H)
    local minute=$(date +%M)
    local current_minutes=$((hour * 60 + minute))

    # Parse the config file to extract profiles
    local in_profile=0
    local profile_time_minutes=-1
    local profile_temp=""
    local profile_gamma=""
    local profile_identity=""

    local active_temp=""
    local active_gamma=""
    local active_identity=""
    local active_time_minutes=-1

    while IFS= read -r line; do
        # Trim whitespace
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        # Check for profile start
        if [[ "$line" == "profile {" ]]; then
            in_profile=1
            profile_time_minutes=-1
            profile_temp=""
            profile_gamma=""
            profile_identity=""
            continue
        fi

        # Check for profile end
        if [[ "$line" == "}" ]] && [[ $in_profile -eq 1 ]]; then
            in_profile=0

            # Check if this profile is applicable (time <= current time)
            if [[ $profile_time_minutes -ge 0 ]] && [[ $profile_time_minutes -le $current_minutes ]]; then
                # This profile is active if it's the latest one before current time
                if [[ $profile_time_minutes -gt $active_time_minutes ]]; then
                    active_time_minutes=$profile_time_minutes
                    active_temp="$profile_temp"
                    active_gamma="$profile_gamma"
                    active_identity="$profile_identity"
                fi
            fi
            continue
        fi

        # Parse profile fields
        if [[ $in_profile -eq 1 ]]; then
            if [[ "$line" =~ ^time[[:space:]]*=[[:space:]]*(.*)$ ]]; then
                local time_str="${BASH_REMATCH[1]}"
                # Parse time (format: HH:MM or H:MM)
                if [[ "$time_str" =~ ^([0-9]+):([0-9]+)$ ]]; then
                    local h="${BASH_REMATCH[1]}"
                    local m="${BASH_REMATCH[2]}"
                    profile_time_minutes=$((h * 60 + m))
                fi
            elif [[ "$line" =~ ^temperature[[:space:]]*=[[:space:]]*([0-9]+)$ ]]; then
                profile_temp="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^gamma[[:space:]]*=[[:space:]]*([0-9.]+)$ ]]; then
                profile_gamma="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^identity[[:space:]]*=[[:space:]]*true$ ]]; then
                profile_identity="true"
            fi
        fi
    done < "$HYPRSUNSET_CONFIG"

    # Check profiles that wrap around midnight (after midnight, before first morning profile)
    # Find the latest profile from yesterday
    in_profile=0
    profile_time_minutes=-1
    profile_temp=""
    profile_gamma=""
    profile_identity=""

    while IFS= read -r line; do
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        if [[ "$line" == "profile {" ]]; then
            in_profile=1
            profile_time_minutes=-1
            profile_temp=""
            profile_gamma=""
            profile_identity=""
            continue
        fi

        if [[ "$line" == "}" ]] && [[ $in_profile -eq 1 ]]; then
            in_profile=0

            # If we haven't found an active profile yet, use the latest from yesterday
            if [[ $active_time_minutes -eq -1 ]] && [[ $profile_time_minutes -ge 0 ]]; then
                if [[ $profile_time_minutes -gt $active_time_minutes ]]; then
                    active_time_minutes=$profile_time_minutes
                    active_temp="$profile_temp"
                    active_gamma="$profile_gamma"
                    active_identity="$profile_identity"
                fi
            fi
            continue
        fi

        if [[ $in_profile -eq 1 ]]; then
            if [[ "$line" =~ ^time[[:space:]]*=[[:space:]]*(.*)$ ]]; then
                local time_str="${BASH_REMATCH[1]}"
                if [[ "$time_str" =~ ^([0-9]+):([0-9]+)$ ]]; then
                    local h="${BASH_REMATCH[1]}"
                    local m="${BASH_REMATCH[2]}"
                    profile_time_minutes=$((h * 60 + m))
                fi
            elif [[ "$line" =~ ^temperature[[:space:]]*=[[:space:]]*([0-9]+)$ ]]; then
                profile_temp="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^gamma[[:space:]]*=[[:space:]]*([0-9.]+)$ ]]; then
                profile_gamma="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^identity[[:space:]]*=[[:space:]]*true$ ]]; then
                profile_identity="true"
            fi
        fi
    done < "$HYPRSUNSET_CONFIG"

    # Output the active settings
    if [[ "$active_identity" == "true" ]]; then
        echo "identity"
    elif [[ -n "$active_temp" ]] && [[ -n "$active_gamma" ]]; then
        echo "$active_temp $active_gamma"
    else
        # Fallback to identity if no valid profile found
        echo "identity"
    fi
}

# Function to restore hyprsunset based on current time
restore_hyprsunset() {
    local settings=$(get_settings_for_time)

    if [[ "$settings" == "identity" ]]; then
        hyprctl hyprsunset identity
    else
        local temp=$(echo "$settings" | cut -d' ' -f1)
        local gamma=$(echo "$settings" | cut -d' ' -f2)
        # Convert gamma from 0-1 scale to 0-100 percentage for hyprctl
        local gamma_percent=$(echo "$gamma * 100" | bc | cut -d'.' -f1)
        hyprctl hyprsunset temperature "$temp"
        hyprctl hyprsunset gamma "$gamma_percent"
    fi
}

# Handle fullscreen events
handle() {
    case $1 in
        fullscreen*)
            # Extract fullscreen state (0 or 1)
            state=$(echo "$1" | cut -d',' -f2)
            if [[ "$state" == "1" ]]; then
                # Entering fullscreen - disable blue light filter
                hyprctl hyprsunset identity
            else
                # Exiting fullscreen - restore based on current time from config
                restore_hyprsunset
            fi
            ;;
    esac
}

# Listen to Hyprland socket for events
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    handle "$line"
done
