#!/bin/bash
Sleep 30
echo "$(grep -B15 -A15 "Timer off" /media/GSM_BC/LOGFILE.TXT | tail -31)" | sudo mail -s "GSM status" runkel@volkerrunkel.de
