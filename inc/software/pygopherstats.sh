#!/bin/bash

if [[ -z $1 ]]; then
	echo "Please provide logfile to scan: "
	echo "./$0 /var/log/syslog"
	exit 1
fi

mkdir -p /var/log/gopherlog/
GOPHERLOG=/var/log/gopherlog/analyze.$(date +%s)

grep pygopherd $@ | awk '{print $6" "$7" "$8" "$9" "$10}' | grep -e GopherProtocol -e HTTPProtocol > ${GOPHERLOG}

LOGSTART=$(grep pygopherd /var/log/syslog | awk '{print $1" "$2" "$3}' | head -n 1)
LOGEND=$(grep pygopherd /var/log/syslog | awk '{print $1" "$2" "$3}' | tail -n 1)

TOTALHITS=$(wc -l $GOPHERLOG | awk '{print $1}')
TOTALIPS=$(awk '{print $1}' ${GOPHERLOG} | sort -u | wc -l)
TOPTENIPS="$(awk '{print $1}' ${GOPHERLOG} | uniq -c | sort -r | head)"
PROTOCOLS="$(awk '{print $2}' ${GOPHERLOG} | sort | uniq -c | sort -r)"
TOPTENFILES="$(awk '{$1=$2=""; print $0}' ${GOPHERLOG} | grep -v "EXCEPTION" | sort | uniq -c | sort -r | head)"
TOPTENERRORS="$(awk '{$1=$2=""; print $0}' ${GOPHERLOG} | grep "EXCEPTION" | sort | uniq -c | sort -r | head)"
TOPTENFILESPERIP="$(grep FileHandler ${GOPHERLOG} | awk '{$2=""; print $0}' |  grep -v "EXCEPTION" | sort | uniq -c | sort -r | head)"
TOPTENGOPHERMAPSPERIP="$(grep BuckGophermapHandler ${GOPHERLOG} | awk '{$2=""; print $0}' |  grep -v "EXCEPTION" | sort | uniq -c | sort -r | head)"
TOPTENDIRSPERIP="$(grep UMNDirHandler ${GOPHERLOG} | awk '{$2=""; print $0}' |  grep -v "EXCEPTION" | sort | uniq -c | sort -r | head)"

if [[ -z ${LOGSTART} || -z ${LOGEND} ]]; then
	echo "No gopher messages found in logfile $1"
	exit 1
fi

echo "# pyGopherd log analyzer"
echo "From file: $@"
echo "Hostname: $(hostname -f || hostname)"
echo "Start: ${LOGSTART}"
echo "End: ${LOGEND}"
echo "----------------------------------"
echo "# Totals "
echo "- Hits: ${TOTALHITS}"
echo "- IP's: ${TOTALIPS}"
echo ""
echo "# Top Tens"
echo "## Most Popular "
echo "${TOPTENFILES}"
echo ""
echo "## Files per IP"
echo "${TOPTENFILESPERIP}"
echo ""
echo "## Gophermaps per IP"
echo "${TOPTENGOPHERMAPSPERIP}"
echo ""
echo "## Folders per IP"
echo "${TOPTENDIRSPERIP}"
echo ""
echo "## Errors: "
echo "${TOPTENERRORS}"
echo 
echo "# Protocols "
echo "${PROTOCOLS}"
echo ""
echo ""
echo "----------------------------------"
echo "Simple pygopherlog analyzer by raymii.org"
echo "License: GNU GPLv3"