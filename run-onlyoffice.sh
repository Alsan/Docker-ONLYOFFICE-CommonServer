#!/bin/bash

service mysql start
service monoserve start
service nginx start
service onlyofficeFeed start
service onlyofficeIndex start
service onlyofficeJabber start
service onlyofficeMailAggregator start
service onlyofficeMailWatchdog start
service onlyofficeNotify start

