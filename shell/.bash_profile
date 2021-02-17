#!/usr/bin/env bash

# Set the path to the root of the mac_bootstrap repo - readlink gives the path of the
# actual .bash_profile file, not the symlink
export BOOTSTRAP_ROOT="$(dirname "$(dirname "$(readlink -n -- "${BASH_SOURCE[0]}")")")"

# Set the base $PATH
export PATH="${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Table of Contents
# ===============================================
#
# 1.LANGUAGE
# 2.HOMEBREW
# 3.HISTORY
# 4.COMMON_ALIASES
# 5.SSH
# 6.GIT
# 7.NODE
# 8.GOLANG
# 9.PYTHON
# 10.RUBY
# 11.DOCKER
# 12.KUBERNETES
# 13.TERRAFORM
# 14.PROMPT
# 15.COMPLETION
# 16.FUNCTIONS
#


# ===============================================
# 1.LANGUAGE
# ===============================================

export LANGUAGE="en"
export LC_MESSAGES="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"


# ===============================================
# 2.HOMEBREW
# ===============================================

# Ensure the Homebrew `bin` directory is in our $PATH
[[ ":$PATH:" != *":/usr/local/bin:"* ]] && PATH="/usr/local/bin:${PATH}"

# Add the GNU Utils to Path
[[ ":$PATH:" != *":/usr/local/opt/gnu-getopt/bin:"* ]] && PATH="/usr/local/opt/gnu-getopt/bin:${PATH}"

# Add coreutils to Path
[[ ":$PATH:" != *":/usr/local/opt/coreutils/libexec/gnubin:"* ]] && PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"


# ===============================================
# 3.HISTORY
# ===============================================

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL="ignoredups"       # no duplicate entries, but keep space-prefixed commands
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history
type shopt &> /dev/null && shopt -s histappend  # append to history, don't overwrite it

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Save multi-line commands as one command
shopt -s cmdhist

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# ===============================================
# 4.COMMON_ALIASES
# ===============================================

# Allow aliases to be 'sudoed'
alias sudo='sudo '

alias ll='ls -lG'
alias la='ls -lahG'
alias ls='ls -lG'


# ===============================================
# 5.SSH
# ===============================================



# ===============================================
# 6.GIT
# ===============================================

export GIT_EDITOR=vim


# ===============================================
# 7.NODE
# ===============================================

if [ ! -d "${HOME}/.nvm" ]; then
  mkdir "${HOME}/.nvm"
fi

export NVM_DIR="${HOME}/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"


# ===============================================
# 8.GOLANG
# ===============================================



# ===============================================
# 9.PYTHON
# ===============================================



# ===============================================
# 10.RUBY
# ===============================================



# ===============================================
# 11.DOCKER
# ===============================================



# ===============================================
# 12.KUBERNETES
# ===============================================



# ===============================================
# 13.TERRAFORM
# ===============================================



# ===============================================
# 14.PROMPT
# ===============================================

[ -s "${BOOTSTRAP_ROOT}/shell/bash_prompt.sh" ] && source "${BOOTSTRAP_ROOT}/shell/bash_prompt.sh"



# ===============================================
# 15.COMPLETION
# ===============================================

# Git
[ -s "/usr/local/etc/bash_completion.d/git-completion.bash" ] && source "/usr/local/etc/bash_completion.d/git-completion.bash"

# NVM
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && source "/usr/local/opt/nvm/etc/bash_completion"


# ===============================================
# 16.FUNCTIONS
# ===============================================

# Kills the Cisco VPN processes, because reliability seems to something Cisco
# deem as unimportant
function killvpn {
  for i in $(ps -ef | grep -i cisco | grep -v grep | awk '{print $2}'); do 
    sudo kill -9 $i; 
  done
}

# Function to clear current AWS STS configuration.
#
# Use this to reset your session to your static AWS_PROFILE configuration
# removing any time-limited temporary credentials from your environment
#
function aws-unset-sts() {
  unset AWS_ACCESS_KEY_ID;
  unset AWS_SECRET_ACCESS_KEY;
  unset AWS_SESSION_TOKEN;
  unset AWS_MFA_EXPIRY;
  unset AWS_SESSION_EXPIRY;
  unset AWS_ROLE;
}
export -f aws-unset-sts;

# Authenticate with an MFA Token Code
function aws-mfa() {

  # Remove any environment variables previously set by sts()
  aws-unset-sts;

  # Get MFA Serial
  #
  # Assumes "iam list-mfa-devices" is permitted without MFA
  mfa_serial="$(aws iam list-mfa-devices --query 'MFADevices[*].SerialNumber' --output text)";
  if ! [ "${?}" -eq 0 ]; then
    echo "Failed to retrieve MFA serial number" >&2;
    return 1;
  fi;

  # Read the token from the console
  echo -n "MFA Token Code: ";
  read token_code;

  # Call STS to get the session credentials
  #
  # Assumes "sts get-session-token" is permitted without MFA
  session_tokens=($(aws sts get-session-token --token-code "${token_code}" --serial-number "${mfa_serial}" --output text));
  if ! [ "${?}" -eq 0 ]; then
    echo "STS MFA Request Failed" >&2;
    return 1;
  fi;

  # Set the environment credentials specifically for this command
  # and execute the command
  export AWS_ACCESS_KEY_ID="${session_tokens[1]}";
  export AWS_SECRET_ACCESS_KEY="${session_tokens[3]}";
  export AWS_SESSION_TOKEN="${session_tokens[4]}";
  export AWS_MFA_EXPIRY="${session_tokens[2]}";

  if [[ -n "${AWS_ACCESS_KEY_ID}" && -n "${AWS_SECRET_ACCESS_KEY}" && -n "${AWS_SESSION_TOKEN}" ]]; then
    echo "MFA Succeeded. With great power comes great responsibility...";
    return 0;
  else
    echo "MFA Failed" >&2;
    return 1;
  fi;
}
export -f aws-mfa;

# Assume an AWS IAM role
#
# param string role       The name of the role to assume
# param string account_id (Optional) The account ID of the role to assume if not the current account
#
function aws-assume-role(){

  declare -a session_tokens;

  local aws_account_id_current="$(aws sts get-caller-identity \
    --output text \
    --query Account)";

  local role="${1}";
  local aws_account_id_target="${2:-${aws_account_id_current}}";

  session_tokens=($(aws sts assume-role \
    --role-arn "arn:aws:iam::${aws_account_id_target}:role/${role}" \
    --role-session-name "${USER}-${HOSTNAME}-${TTYNR}" \
    --query Credentials \
    --output text; ));

  if ! [ "${?}" -eq 0 ]; then
    echo "STS Assume Role Request Failed" >&2;
    return 1;
  fi;

  # Set the environment credentials specifically for this command
  # and execute the command
  export AWS_ACCESS_KEY_ID="${session_tokens[0]}";
  export AWS_SECRET_ACCESS_KEY="${session_tokens[2]}";
  export AWS_SESSION_TOKEN="${session_tokens[3]}";
  export AWS_SESSION_EXPIRY="${session_tokens[1]}";

  if [[ \
       -n "${AWS_ACCESS_KEY_ID}"     \
    && -n "${AWS_SECRET_ACCESS_KEY}" \
    && -n "${AWS_SESSION_TOKEN}"     \
  ]]; then
    export AWS_ROLE="${role}"
    echo "Succeessfully assumed the ${role} role. With great power comes great responsibility...";
    return 0;
  else
    echo "STS Assume Role Failed" >&2;
    return 1;
  fi;
}
export -f aws-assume-role


# ===============================================
# 17.SCRIPTS
# ===============================================

for script in ${BOOTSTRAP_ROOT}/scripts/2*.sh; do
  source ${script}
done
unset script

for script in ${BOOTSTRAP_ROOT}/scripts/3*.sh; do
  screen -dm -S Shared ${script}
done
unset script

