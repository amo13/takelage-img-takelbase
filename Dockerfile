FROM debian:bookworm-slim

RUN rm -fr /sbin/initctl
COPY --chmod=755 <<EOF /sbin/initctl
#!/bin/sh
ALIAS_CMD="$(echo "$0" | sed -e 's?/sbin/??')"
case "$ALIAS_CMD" in
    start|stop|restart|reload|status)
        exec service "$1" "$ALIAS_CMD"
        ;;
esac
case "$1" in
    list )
        exec service --status-all
        ;;
    reload-configuration )
        exec service "$2" restart
        ;;
    start|stop|restart|reload|status)
        exec service "$2" "$1"
        ;;
    ?)
        exit 0
        ;;
esac
EOF

RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get install -y --no-install-recommends python3 python3-apt sudo systemd
RUN apt-get clean

EXPOSE 80
EXPOSE 443
EXPOSE 1337
EXPOSE 5432
EXPOSE 8101
