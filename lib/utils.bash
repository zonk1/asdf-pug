#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/leg100/pug"
TOOL_NAME="pug"
TOOL_TEST="pug --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

check_dependencies() {
  # Check if unzip is installed
  if ! command -v unzip &> /dev/null; then
    echo "Error: unzip is not installed. Please install it and try again."
    exit 1
  fi
}

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local platform
  case "$OSTYPE" in
    darwin*) platform="darwin" ;;
    linux*) platform="linux" ;;
    msys*) platform="windows" ;;
    *) fail "Unsupported platform" ;;
  esac

  local arch
  case "$(uname -m)" in
    x86_64) arch="amd64" ;;
    arm64 | aarch64) arch="arm64" ;;
    *) fail "Unsupported architecture" ;;
  esac

  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${platform}_${arch}.zip"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/pug "$install_path"
    mkdir -p "$install_path/../share/doc"
    cp -r "$ASDF_DOWNLOAD_PATH"/{LICENSE,CHANGELOG.md,README.md} "$install_path/../share/doc"
    chmod +x "$install_path/$TOOL_NAME"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
