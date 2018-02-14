#!/bin/bash

if [ $# == 2 ] && \
    [ $1 -ge 0 ] && [ $1 -lt 32767 ] && \
    [ $2 -ge 1 ] && [ $2 -le 32767 ] && \
    [ $2 -gt $1 ]
then
    echo $(( $RANDOM % $2 + $1 ))
fi
