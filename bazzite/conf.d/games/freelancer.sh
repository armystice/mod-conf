#!/bin/bash
INSTALL_DIR=$1

WINEPREFIX="${INSTALL_DIR}" winetricks vcrun6sp6 riched30 directplay
echo "Next steps:
1) Install Freelancer from CD
2) Create a launcher for the game with the following:
    Game options->Prefix Architecture->Auto
    Runner options->Wine version->System
"