#!/usr/bin/env bash
# Licensed under the MIT license. See LICENSE file on the project webpage for details.

set -ex

get_current_branch()
{
    local branchInfo=

    if [[ -n $CIRCLE_BRANCH ]] ; then
        branchInfo=$CIRCLE_BRANCH
    else
        # Current branch is prefixed with an asterisk. Remove it.
        local prefix='* '
        branchInfo=$(git branch | grep "$prefix" | sed "s/$prefix//g")
    fi

    echo "$branchInfo"
}

get_base_branch()
{
    local baseBranch=

    if [[ -n $CIRCLE_PULL_REQUEST ]] ; then
        # Construct github API url
        local g="github.com"
        local apiURL=$(echo "$CIRCLE_PULL_REQUEST" | sed "s#/$g/#/api.$g/repos/#g" | sed "s#/pull/#/pulls/#g") > /dev/null
        baseBranch=$(curl -sSl $apiURL | jq -r '.base.ref')
    fi

    echo "$baseBranch"
}

is_valid_branch()
{
    local branch=$1

    # Is branch useful?
    [[ -n "$branch" ]] && [[ $branch != null ]] && [[ $branch != *"no branch"* ]] && [[ $branch != *"detached"* ]]
}

branch_in_list()
{
    local branch=$1

    for filter in $ONLY_BRANCHES; do
        if [[ $branch == $filter ]] ; then
            true
        fi
    done

    false
}

sudo apt update
sudo apt install -y jq curl

current_branch=$(get_current_branch)
if is_valid_branch $current_branch ; then
    if branch_in_list $current_branch ; then
        exit 0
    fi
fi

env

base_branch=$(get_base_branch)
if is_valid_branch $base_branch ; then
    if branch_in_list $base_branch ; then
        exit 0
    fi
fi

exit 1
