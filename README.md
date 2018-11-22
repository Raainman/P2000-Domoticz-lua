# P2000-Domoticz-lua
Retrieve P2000 messages (the Netherlands only) to be shown in a text sensor, and telegram message

Create 2 dummy text devices in Domoticz;
P2000
MaxP2000

Then also fill in the telegram settings

The lua file should be placed in the dzEvents/scripts directory on your Domoticz installation

monitor your log file for any problems, the P2000 sensor should be filled with the latest P2000 message based on your filter settings.
