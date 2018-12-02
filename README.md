# P2000-Domoticz-lua
Retrieve P2000 messages (the Netherlands only) to be shown in a text sensor, and telegram message

Create 1 dummy text device in Domoticz;

P2000

In the 'parameters to be set" section you can modify which P2000 messages should be selected.

The lua file should be placed in the dzEvents/scripts directory on your Domoticz installation

monitor your log file for any problems, the P2000 sensor should be filled with the latest P2000 message based on your filter settings.

Only the newest messages will be retrieved, based on the previous result
