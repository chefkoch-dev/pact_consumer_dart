#!/bin/bash

# Constants
HOST="127.0.0.1"
PORT="1234"
NAME="pact"

# BEGIN FUNCTION DECLARATIONS

# Stops the container and removes it
function stopContainer() {
  bundle exec pact-mock-service stop --pid-dir=/tmp/contracts/pids &>/dev/null
}

# Sets up the Pact Service using docker and attempts to validate the service is running correctly
function setupPact() {
  if bundle exec pact-mock-service start -p 1234 --pact-dir=/tmp/contracts/pacts --pid-dir=/tmp/contracts/pids -l /tmp/log/service.log
  then

    if sleep 1 && curl -XDELETE -f -H "X-Pact-Mock-Service: true" $HOST:$PORT/interactions &>/dev/null
    then
      echo "Pact Setup Complete!"
      echo "Pact Service is running on $HOST:$PORT!"
    else
      echo "Failed while validating the Pact Service is running!"
      stopContainer
      exit 1
    fi

  else
    echo "Failed loading Pact Service from docker image!"
    exit 1
  fi
}

# END FUNCTION DECLARATIONS
#-------------------------------------------------------#
# BEGIN SCRIPT

setupPact

# Condition executes the integration tests on the dart vm via dart_dev
if pub run dart_dev test test/integration --test-args "--concurrency=1"
then
  echo "Contract Tests Complete!"
  stopContainer
  exit 0
else
  echo "Contract Tests Failed!"
  stopContainer
  exit 1
fi

# END SCRIPT
