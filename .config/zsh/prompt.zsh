# Variables for prompt
export NEWLINE=$'\n'
export USERNAME="%n"
export MACHINE="%m"
export DIRECTORY="%~"
export TIME="%T"

# Font
export BOLD_START="%B"
export BOLD_STOP="%b"

export UNDERLINE_START="%U"
export UNDERLINE_STOP="%u"

# Colors
Black="%F{0}"
Maroon="%F{1}"
Green="%F{2}"
Olive="%F{3}"
Navy="%F{4}"
Purple="%F{5}"
Teal="%F{6}"
Silver="%F{7}"
Grey="%F{8}"
Red="%F{9}"
Lime="%F{10}"
Yellow="%F{11}"
Blue="%F{12}"
Fuchsia="%F{13}"
Aqua="%F{14}"
White="%F{15}"

Better_Blue="%F{27}"

export EMPHESIS_COLOR_START="$Blue$BOLD_START"
export EMPHESIS_COLOR_STOP="$White$BOLD_STOP"

local git_branch='$(git branch-name)'
local git_email='$(git email)'
local git_name='$(git name)'
local git_absolute='$(git absolute)'

set_prompt() {
    git dir
    if [[ $? -eq 0 ]]; then
        PROMPT="$EMPHESIS_COLOR_START$USERNAME$EMPHESIS_COLOR_STOP on $EMPHESIS_COLOR_START$MACHINE$EMPHESIS_COLOR_STOP in $EMPHESIS_COLOR_START$DIRECTORY$EMPHESIS_COLOR_STOP on $EMPHESIS_COLOR_START ${git_branch}$EMPHESIS_COLOR_STOP"
    else
        PROMPT="$EMPHESIS_COLOR_START$USERNAME$EMPHESIS_COLOR_STOP on $EMPHESIS_COLOR_START$MACHINE$EMPHESIS_COLOR_STOP in $EMPHESIS_COLOR_START$DIRECTORY$EMPHESIS_COLOR_STOP"
    fi
    PROMPT+="$NEWLINE"
    PROMPT+="$White$(date +%H:%M) $EMPHESIS_COLOR_START<>$EMPHESIS_COLOR_STOP "
}

precmd() {
    set_prompt
}
