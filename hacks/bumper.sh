#!/bin/bash -e

REPO_BASE="$(git rev-parse --show-toplevel)"
DOCKERFILE_PATH="$REPO_BASE/Dockerfile"
README_PATH="$REPO_BASE/README.md"
CONFIG_PATH="$REPO_BASE/hacks/config.json"

function get_latest() {
    local url="$1"

    latest=$(curl -Ls $url |jq -r .tag_name)
    export latest=${latest//v}
}

for item in terraform terragrunt opa conftest; do
    tool_config=$(cat $CONFIG_PATH | jq -r ".$item")

    url=$(echo $tool_config | jq -r .repo_url)
    get_latest $url

    version_regex=$(echo $tool_config | jq -r .version_regex | envsubst)
    badge_regex=$(echo $tool_config | jq -r .badge_regex | envsubst)

    sed -i "$version_regex" $DOCKERFILE_PATH
    sed -i "$badge_regex" $README_PATH
done
