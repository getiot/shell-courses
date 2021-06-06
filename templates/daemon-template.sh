#!/bin/sh
# Start/stop the test daemon.
#
### BEGIN INIT INFO
# Provides:          test
# Required-Start:    $remote_fs $syslog $time
# Required-Stop:     $remote_fs $syslog $time
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Execute the test command.
# Description:       Test templates
### END INIT INFO

do_start() {
    echo "start"
}

do_stop() {
    echo "stop"
}

do_restart() {
    echo "restart"
}

do_status() {
    echo "status"
}

do_fallback() {
    echo "fallback"
}

case "$1" in
start) do_start
      ;;
stop)  do_stop
      ;;
restart) do_restart
      ;;
status) do_status
      ;;
*)     do_fallback
      ;;
esac
exit 0
