# ublog
ublog source code


Prerequisites
-------------
* erlang (v 20 or higher)
* postgresql (v 9.5 or higher)
* pgbouncer (optional - change port to postgresql)
* nginx (optional - change websocket_port to default)
* letsencrypt certbot (optional)
* make
* inotify-tools (Linux, for filesystem watching)

Includes
---
* n2o ( github.com/synrc/n2o )
* nitro ( github.com/synrc/nitro )
* mad ( github.com/synrc/mad )
* otp.mk ( github.com/synrc/otp.mk )
* erlydtl ( github.com/evanmiller/erlydtl )
* epgsql ( github.com/epgsql/epgsql )
* epgsql_pool ( github.com/wgnet/epgsql_pool )
* vanilla.js ( vanilla-js.com )

Run
---
On Linux

    $ ./mad deps compile plan repl
    $ CTRL + C
    $ make start
    $ make attach
    $ CTRL + D


