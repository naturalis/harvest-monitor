[![Build Status](https://travis-ci.org/naturalis/harvest-monitor.svg?branch=master)](https://travis-ci.org/naturalis/harvest-monitor)

# harvest-monitor
Small web application for monitoring the medialib CRS harvest errors.

## Running
Easiest deployment is with [Docker](https://www.docker.com/). To run the harvest monitor on a server, you must provide
`username`, `password` and the details of the CRS oarcle database server in the form `server:port/dbname`. With the `-p` argument you specify on which port the server is listening, in the below example this is port 80:

    docker run -p 80:3838 -it -e USER=username -e PASS=password -e SERVER=server:port/database naturalis/harvest-monitor

