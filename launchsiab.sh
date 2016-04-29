#!/bin/bash
echo "Launching SIAB!"
/usr/local/bin/shellinaboxd -t -b && tail -f /dev/null
echo "Running SIAB"
