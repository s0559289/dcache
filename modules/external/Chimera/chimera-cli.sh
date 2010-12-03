#!/bin/sh


if [ $# -lt 2 ]
then
    echo "Usage <command> <path> [options]"
    exit 1
fi

command=$1
shift

# Initialize environment. /etc/default/ is the normal place for this
# on several Linux variants. For other systems we provide
# /etc/dcache.env. Those files will typically declare JAVA_HOME and
# DCACHE_HOME and nothing else.
[ -f /etc/default/dcache ] && . /etc/default/dcache
[ -f /etc/dcache.env ] && . /etc/dcache.env

# Set home path
if [ -z "$DCACHE_HOME" ]; then
    DCACHE_HOME="/opt/d-cache"
fi
if [ ! -d "$DCACHE_HOME" ]; then
    echo "$DCACHE_HOME is not a directory"
    exit 2
fi

. ${DCACHE_HOME}/share/lib/loadConfig.sh

CLASSPATH="$(getProperty dcache.paths.classpath)" \
    ${JAVA} $(getProperty dcache.java.options) \
    "-Dlogback.configurationFile=$(getProperty dcache.paths.share)/xml/logback-cli.xml" \
    org.dcache.chimera.examples.cli.${command} ${DCACHE_CONFIG}/chimera-config.xml $*
