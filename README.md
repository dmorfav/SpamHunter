# SpamHunter
A script for block domains and email address in a Zimbra Mail Server

## Description
This script help you to block incoming emails from a email address or domain in a zimbra mail server, the process consist in create a list of emails address or domains and add this in the postfix config

## Instalation
1. Clone the repository in your Zimbra Mail Server
2. Move the script **SpamHunter.sh** to */usr/bin/* for use global `mv SpamHunter.sh /usr/bin/SpamHunter`

## Usage
the script can be used in two ways, one following the interactive mode which is executed by default if you do not pass any parameters and the other is passing parameters in the command

  ### Using with parameters
  - **Add** `MailHunter a email@domain.com`
  - **Update** `MailHunter a OldDomain NewDomain`
  - **Delete** `MailHunter e domain`
  - **List** `MailHunter l`
