#!/usr/bin/env bash



if [[ -z "${SOCAT_WYZE_TYPE}" ]]; then

  SOCAT_WYZE_TYPE="tcp"

fi

if [[ -z "${SOCAT_WYZE_LOG}" ]]; then

  SOCAT_WYZE_LOG="-lf \"$SOCAT_WYZE_LOG\""

fi

if [[ -z "${SOCAT_WYZE_LINK}" ]]; then

  SOCAT_WYZE_LINK="/dev/wyze"

fi



# No socat host/port set? Then do not complain and just exit.

if [[ -z "${SOCAT_WYZE_HOST}" ]]; then

  exit 1

fi

if [[ -z "${SOCAT_WYZE_PORT}" ]]; then

  exit 1

fi



BINARY="socat"

PARAMS="$INT_SOCAT_LOG-d pty,link=$SOCAT_WYZE_LINK,raw,user=root,mode=777 $SOCAT_WYZE_TYPE:$SOCAT_WYZE_HOST:$SOCAT_WYZE_PORT"



######################################################



CMD=$1



if [[ -z "${CONFIG_LOG_TARGET}" ]]; then

  LOG_FILE="/dev/null"

else

  LOG_FILE="${CONFIG_LOG_TARGET}"

fi



case $CMD in



describe)

    echo "Sleep $PARAMS"

    ;;



## exit 0 = is not running

## exit 1 = is running

is-running)

    if pgrep -f "$BINARY $PARAMS" >/dev/null 2>&1 ; then

        exit 1

    fi

    # stop home assistant if socat is not running 

    if pgrep -f "python -m homeassistant" >/dev/null 2>&1 ; then

        echo "stopping home assistant since socat is not running"

        kill -9 $(pgrep -f "python -m homeassistant")

    fi

    exit 0

    ;;



start)

    echo "Starting... $BINARY $PARAMS" >> "$LOG_FILE"

    $BINARY $PARAMS 2>$LOG_FILE >$LOG_FILE &

    # delay other checks for 5 seconds

    sleep 5

    ;;



start-fail)

    echo "Start failed! $BINARY $PARAMS"

    ;;



stop)

    echo "Stopping... $BINARY $PARAMS"

    kill -9 $(pgrep -f "$BINARY $PARAMS")

    ;;



esac
