#!/bin/bash

LOG="/tmp/hdr_toggle.log"
KSCREEN="/usr/bin/kscreen-doctor"
NOTIFY="/usr/bin/notify-send"

echo "=== HDR Toggle Triggered ===" >> "$LOG"
$KSCREEN -o >> "$LOG"

HDR_STATE=$($KSCREEN -o | grep -oP '(?<=HDR: )\w+')
echo "Parsed HDR state: $HDR_STATE" >> "$LOG"

if [ "$HDR_STATE" = "enabled" ]; then
  echo "Disabling HDR..." >> "$LOG"
  $KSCREEN output.DP-2.hdr.disable
  $NOTIFY "HDR Disabled"
else
  echo "Enabling HDR..." >> "$LOG"
  $KSCREEN output.DP-2.hdr.enable
  $NOTIFY "HDR Enabled"
fi
