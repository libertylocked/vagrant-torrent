#!/bin/sh
# To make qBittorrent data and config portable, we save the qbittorrent data 
# and config in downloads folder.
PORTABLE_HOME=$HOME/downloads/.qbit
REL_DATA_DIR=.local/share/data
REL_CONFIG_DIR=.config

# symlink qbittorrent data
mkdir -p $PORTABLE_HOME/$REL_DATA_DIR/qBittorrent
mkdir -p $HOME/$REL_DATA_DIR
if [ ! -L $HOME/$REL_DATA_DIR/qBittorrent ]; then
  echo "Creating qBittorrent data symlink"
  ln -s $PORTABLE_HOME/$REL_DATA_DIR/qBittorrent/ $HOME/$REL_DATA_DIR/qBittorrent
fi

# symlink qbittorrent config
mkdir -p $PORTABLE_HOME/$REL_CONFIG_DIR/qBittorrent
mkdir -p $HOME/$REL_CONFIG_DIR
if [ ! -L $HOME/$REL_CONFIG_DIR/qBittorrent ]; then
  echo "Creating qBittorrent config symlink"
  ln -s $PORTABLE_HOME/$REL_CONFIG_DIR/qBittorrent/ $HOME/$REL_CONFIG_DIR/qBittorrent
fi

# write default if no config exists
if [ ! -f "$HOME/$REL_CONFIG_DIR/qBittorrent/qBittorrent.conf" ]; then
  echo "Copying qBittorrent default config"
  cp $HOME/.config_default/qBittorrent/qBittorrent.conf $HOME/$REL_CONFIG_DIR/qBittorrent
fi

# qbittorrent config patching
SETTINGS_FILE="$HOME/.provision_config/settings.json"
QBCONF=$HOME/$REL_CONFIG_DIR/qBittorrent/qBittorrent.conf
IFACE=$(cat $HOME/.provision_config/iface)
sed -i "/^Connection\\\\Interface=/s/=.*/=$IFACE/" $QBCONF
sed -i "/^Connection\\\\InterfaceName=/s/=.*/=$IFACE/" $QBCONF
echo "Set qBittorrent connection interface to $IFACE"
if [ ! -f $SETTINGS_FILE ]; then
  SETTINGS_FILE="$SETTINGS_FILE.default"
fi
PORT=$(jq '.port' < $SETTINGS_FILE)
sed -i "/^WebUI\\\\Port=/s/=.*/=$PORT/" $QBCONF
echo "Set qBittorrent WebUI port to $PORT"

# delete the configs so next reprovision won't use old configs
rm -rf $HOME/.provision_config