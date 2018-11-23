# P2000-Domoticz-lua
Retrieve P2000 messages (the Netherlands only) to be shown in a text sensor, and telegram message

Create 2 dummy text devices in Domoticz;

P2000

MaxP2000

Then also fill in the telegram settings

In the 'parameters to be set" section you can modify which P2000 messages should be selected.

The lua file should be placed in the dzEvents/scripts directory on your Domoticz installation

monitor your log file for any problems, the P2000 sensor should be filled with the latest P2000 message based on your filter settings.

The MaxP2000 sensor will contain the highest message id retrieved, so that only the newest messages will be retrieved

Todo: Change MaxID to persistent data
Once lua 2.4.8 is in the stable Domoticz, I will change that the Telegram will be sent via notification system (not possible in the current lua 2.4.6)
