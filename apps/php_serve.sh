#!/bin/bash

# exit code 1 is a php error
exit_missing_port=2
exit_invalid_port=3

usage(){
  echo "Devserve:
  Starts a development server on a given port number
  Usage: devserve [port:n+]"
}

port=$1

if [ -z $port ] ; then
  usage
  exit $exit_missing_port
fi

if [[ ! $port =~ ^[0-9]+$ ]] ; then
  usage
  exit $exit_invalid_port
fi

host="0.0.0.0:$port"

echo "Starting local development server on:
  http://$host
"

php -S $host
