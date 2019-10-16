#!/bin/sh

sudo apt update
sudo apt upgrade

sudo apt install apache2 apache2-utils

sudo systemctl enable apache2
sudo systemctl restart apache2
