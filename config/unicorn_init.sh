#!/bin/bash
### BEGIN INIT INFO
# Provides:          unicorn
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start;     2 3 4 5
# Default-Stop;      0 1 6 
# Short-Description; Manage unicorn server
# Description;       Start, stop, restart unicorn server for a specific application
### END INIT INFO
set -e

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=/srv/http/app.example.com/current/
PID=$APP_ROOT/tmp/pids/unicorn.pid
CMD="cd $APP_ROOT; bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E production"
AS_USER=deployer
set -u

OLD_PID="$PID.oldbin"

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s "$OLD_PID" && kill -$1 `cat $OLD_PID`
}

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
    eval $1
  else
    su -c "$1" - $AS_USER
  fi
}

case $1 in
  start)
    echo "Starting unicorn server..."
    sig 0 && echo >&2 "Already running" && exit 0
    run "$CMD"
    ;;
  stop)
    echo "Stopping unicorn server..."
    sig QUIT && exit 0
    echo >&2 "Not running"
    ;;
  force-stop)
    echo "Stopping unicorn server..."
    sig TERM && exit 0
    echo >&2 "Not running"
    ;;
  restart|reload)
    echo "Restarting unicorn server..."
    sig HUP && echo "reloaded OK" && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    run "$CMD"
    ;;
  upgrade)
    if [ sig USR2 ] && [ sleep 2 ] && [ sig 0 ] && [ oldsig QUIT ]; then
      n=$TIMEOUT
      while [ -s $OLD_PID ] && [ $n -ge 0 ]; do
        printf '.' && sleep 1 && n=$(( $n - 1 ))
      done
      echo

      if [ $n -lt 0 ] && [ -s $OLD_PID ]; then
        echo >&2 "Process $OLD_PID still exists after $TIMEOUT seconds"
        exit 1
      fi
      exit 0
    fi
    echo >&2 "Coundn't upgrade, starting '$CMD' instead"
    run "$CMD"
    ;;
  reopen-logs)
    sig USR1
    ;;
  *)
    echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
    exit 1
    ;;
esac