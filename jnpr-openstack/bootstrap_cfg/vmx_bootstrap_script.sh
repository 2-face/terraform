#!/bin/sh
/usr/sbin/cli -c "configure private; set system scripts op file login-script.slax; commit"
/usr/sbin/cli -c "configure private; set groups global system login user admin authentication plain-text-password-value P@$$w0rd321!; commit"
/usr/sbin/cli -c "configure private; set groups global system login class super-user-with-login-script login-script login-script.slax; commit"
/usr/sbin/cli -c "configure private; set groups global system root-authentication plain-text-password-value P@$$w0rd321!; commit"