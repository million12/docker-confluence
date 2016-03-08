#!/bin/sh
set -eu
export TERM=xterm

# Bash Colors
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`

#OS VARIABLES
INSTALL_DIR='/opt/atlassian/confluence'
INSTALLATION_STATUS='/opt/atlassian/confluence/bin/start-confluence.sh'
PID=`ps ax | grep start-confluence | grep -v grep | awk '{print $1}'`

# Functions
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@";
  else echo; fi
}
# Magic starts here
stop_confluence() {
  log "Stopping confluence"
  /opt/atlassian/confluence/bin/stop-confluence.sh
  log "confluence Stopped"
}

install_confluence() {
  log "Startting installation of Confluence version: ${CONFLUENCE_VERSION}"
  log "Downloading..."
  curl -L https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}-x64.bin -o /tmp/confluence.bin
  chmod +x /tmp/confluence.bin
  log "Installing..."
  cd /tmp
  ./confluence.bin <<<"o
1
i
"
  log "Confluence Installed."
}

install_mysql_connector() {
  log "Installing mysql-connector."
  log "Downloading mysq-connector"
  curl -L http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.37.tar.gz -o /tmp/mysql-connector-java-5.1.37.tar.gz
  mkdir -p /tmp/mysql-connector/
  tar zxvf /tmp/mysql-connector-java-5.1.37.tar.gz -C /tmp/mysql-connector/ --strip-components=1
  cp /tmp/mysql-connector/mysql-connector-java-5.1.37-bin.jar ${INSTALL_DIR}/lib/
  log "mysql-connector Installed."
}

clean_all() {
  log "Removing all temporary files."
  rm -rf /tmp/mysql-connector-java-5.1.37.tar.gz
  rm -rf /tmp/mysql-connector/
  rm -rf /tmp/confluence.bin
  log "All cleaned. System ready! "
}

if [[ ! -e "${INSTALLATION_STATUS}" ]]; then
  install_confluence
else
  log "Confluence already installed. Adding missing users and groups"
  getent group confluence || groupadd -g 1000 confluence
  getent passwd confluence || useradd -u 1001 -g 1000 confluence
  log " Fixing Permissions"
  chown -R confluence:confluence /opt/atlassian/
fi

if [[ ${DB_SUPPORT} == "mysql" ]]; then
  install_mysql_connector
fi

if [[ -e "${PID}" ]]; then
  stop-confluence
fi

if [[ -e "/tmp/mysql-connector-java-5.1.37.tar.gz" ]]; then
  clean_all
fi
