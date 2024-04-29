#!/usr/bin/env bash

set -eo pipefail
shopt -s nocasematch

# Console colour highlight codes
DEFAULT_HIGHLIGHT="\e[0m"
HIGHLIGHT_YELLOW="\e[33m"
HIGHLIGHT_GREEN="\e[32m"
HIGHLIGHT_RED="\e[31m"
HIGHLIGHT_BLUE="\e[34m"

# Highlight a message in the console
function highlight() {
    COLOUR="$1"
    MESSAGE="$2"

    case $COLOUR in

    "yellow")
        printf "$HIGHLIGHT_YELLOW"%s"$DEFAULT_HIGHLIGHT" "$MESSAGE"
        ;;
    "green")
        printf "$HIGHLIGHT_GREEN"%s"$DEFAULT_HIGHLIGHT" "$MESSAGE"
        ;;
    "red")
        printf "$HIGHLIGHT_RED"%s"$DEFAULT_HIGHLIGHT" "$MESSAGE"
        ;;
    "blue")
        printf "$HIGHLIGHT_BLUE"%s"$DEFAULT_HIGHLIGHT" "$MESSAGE"
        ;;
    *)
        printf %s "$MESSAGE"
        ;;
    esac
    echo ""
}

function bootstrap() {
    local profile=$1
    local extra_flags=$2
    highlight green "running command:"
    highlight yellow "cdk bootstrap --profile $profile $extra_flags"
    # cdk bootstrap --profile $profile
    printf "\n"
}

function deploy() {
    local profile=$1
    highlight green "running command:"
    highlight yellow "cdk deploy --profile $profile"
    # cdk deploy --profile $profile
    printf "\n"
}

# Admin for all
case_one() {
    bootstrap admin
    deploy admin
}

# Admin for bootstrap only
case_two() {
    bootstrap admin
    deploy assume_only
}

#  Bootstrap with a passed policy
case_three() {
    bootstrap "admin" "--cloudformation-execution-policies \"arn:aws:iam::aws:policy/AWSLambda_FullAccess\""
    deploy assume_only
}

#  Resticted bootstrap role
case_four() {
    bootstrap "restricted" "--cloudformation-execution-policies \"arn:aws:iam::aws:policy/AWSLambda_FullAccess\""
    deploy assume_only
}

#  Permissions boundary
case_five() {
    bootstrap "restricted" "--custom-permissions-boundary developer-policy"
    deploy assume_only
}

error() {
    highlight red "Incorrect args provided" && exit 1
}

[ -z "$1" ] && error

case $1 in

"CASE_ONE")
    case_one
    ;;
"CASE_TWO")
    case_two
    ;;
"CASE_THREE")
    case_three
    ;;
"CASE_FOUR")
    case_four
    ;;
"CASE_FIVE")
    case_five
    ;;
*)
    error
    ;;
esac
