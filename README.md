### scm-mmconf
This is small program that connects to ModemManager's DBus and configures modem's interface.

#### Why?
Because only program capable of communicating with ModemManager is NetworkManager which I personally dislike and which wasn't even working (ModemManager is able to connect but NetworkManager is not). With this I can use netctl and still be able to start and configure modem when I deem so.

#### Why Scheme?
Why not? Shells don't have good support for DBus, nor has Lua. Scheme was my next language of choice.

#### How to run it?
You have to install Chicken and two eggs `dbus` and `vector-lib`. To configure the interface you have to run it from root, it uses `ip` command to configure interface. Don't forget to customize the program with you system configuration.

### License

Copyright © 2016 Jakub Sztandera <k.sztandera@protonmail.ch>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To But It's Not My Fault, Version1
as published by Ben McGinnes. See the LICENSE file for more details.


