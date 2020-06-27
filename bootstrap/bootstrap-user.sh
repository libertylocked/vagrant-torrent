#!/bin/sh
# symlink qbittorrent data to downloads
mkdir -p $HOME/downloads/data/qBittorrent
mkdir -p $HOME/.local/share/data
ln -s $HOME/downloads/data/qBittorrent/ $HOME/.local/share/data/qBittorrent