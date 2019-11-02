#!/bin/sh

sudo apt update
sudo apt -y upgrade

sudo apt install -y apache2 apache2-utils

sudo systemctl enable apache2
sudo systemctl restart apache2
