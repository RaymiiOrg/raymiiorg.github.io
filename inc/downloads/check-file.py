#!/usr/bin/python

    # Copyright (C) 2012  Remy van Elst

    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <http://www.gnu.org/licenses/>.


import os
import os.path
import argparse
import smtplib
import hashlib
import socket
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formatdate
hostname = socket.gethostname()

parser = argparse.ArgumentParser(description="Check the MD5 sum of a file, and report when it is changed.")
parser.add_argument("file",
                    help="Full path to file to monitor for changes")

parser.add_argument("-c", "--checksum-compare",
                    help="MD5 checksum to compare the file to. If not given, last checked checksum is used.")

parser.add_argument("-o", "--overwrite-checksum", help="Overwrite the checksum with the new one.",
        default=False, action="store_true")

parser.add_argument("-e", "--email", 
                    help="Email address to mail report to.", default="root@" + hostname)

parser.add_argument("-a", "--attach-file", help="Attach the file to the email message.",
                    default=False, action="store_true")

parser.add_argument("-s", "--smtp", help="Hostname or IP address of SMTP server",
                     default="localhost")

parser.add_argument("-f", "--sender", help="The from address of the email.",
                    default="filechecker@" + hostname)
parser.add_argument("-m", "--mail-on-match", help="Send an email when the file is not changed",
                    default=False, action="store_true")

args = parser.parse_args()

mail_to=args.email
mail_from=args.sender
attach_file=args.attach_file
smtp_server=args.smtp
filename=args.file
abspath = os.path.abspath(args.file)
basename = os.path.basename(abspath)
checksum_compare=args.checksum_compare
overwrite_checksum=args.overwrite_checksum
mail_on_match=args.mail_on_match
savefilename = str(abspath).replace('/','-')
savefilename = str(savefilename).replace('-','',1)

tmpdir="/tmp/"
dateTime = formatdate(localtime=True)
checksumTempFilename = os.path.abspath(tmpdir) + '/' + str(savefilename) + ".md5"
version = "0.1"
matches = 0

def file_checksum(filename):

    try:
        fh = open(filename, 'rb')
    except:
        error = "Cannot open file: ", filename
        raise
    m = hashlib.md5()
    while True:
        data = fh.read(8192)
        if not data:
            break
        m.update(data)
    return m.hexdigest()



def compare_checksum(filename, checksumToCompare=None, save=False):
    global tmpdir
    global overwrite_checksum
    global dateTime
    global hostname
    global version
    global matches
    global checksumTempFilename
    checksumFilename = checksumTempFilename
    compareGiven = False
    fileCheckSum = file_checksum(abspath)
    message = "File checksum report (v %s).\n\n" % version
    message += "Date: %s. \n" % dateTime
    message += "Hostname: %s.\n\n" % hostname
    
    if checksumToCompare != None:
        compareGiven = True
        # We have a set checksum to compare to
        if str(fileCheckSum) == str(checksumToCompare):
            ## Checksum matches
            message += "=== Checksum matches. ===\n" 
            message += "\n\n\n"
            message += "Old: %s. \n" % checksumToCompare
            message += "New: %s. \n" % fileCheckSum
            message += "Filename: %s. \n" % abspath
            message += "Checksum was given to me.\n"
            matches = 1
        else:
            message += "=== Checksum does NOT match. ===\n" 
            message += "\n\n\n"
            message += "Old: %s. \n" % checksumToCompare
            message += "New: %s. \n" % fileCheckSum
            message += "Filename: %s. \n" % abspath
            message += "Checksum was given to me.\n"
    else:
        # we have to check in history
        if os.path.exists(checksumFilename):
            checksumToCompare = open(checksumFilename, 'r')
            checksumToCompare = str(checksumToCompare.read())

        else:
            # First time to check
            message += "=== Checksum for file %s not found in history. ===\n" % abspath
            message += "Saving checksum to: %s. \n" % checksumFilename
            message += save_checksum(basename, fileCheckSum)
            return message

        if str(fileCheckSum) == str(checksumToCompare):
            ## Checksum matches
            message += "=== Checksum matches. ===\n"
            message += "\n\n\n" 
            message += "Old: %s. \n" % checksumToCompare
            message += "New: %s. \n" % fileCheckSum
            message += "Filename: %s. \n" % abspath
            message += "I checksummed the file itself.\n"
            matches = 1
            
        else:
            message += "=== Checksum does NOT match. ===\n" 
            message += "\n\n\n"
            message += "Old: %s. \n" % checksumToCompare
            message += "New: %s. \n" % fileCheckSum
            message += "Filename: %s. \n" % abspath
            message += "I checksummed the file itself.\n"
            
    if save == True and compareGiven == False:
        message += "Overwriting old checksum with new checksum as requested. \n"
        message += save_checksum(basename, fileCheckSum)


    return message





def save_checksum(filename, checksum):
    global tmpdir
    global savefilename
    global checksumTempFilename
    checksumFilename = checksumTempFilename
    # checksumFilename = os.path.abspath(tmpdir) + '/' + str(savefilename) + ".md5"

    checksumFile = open(checksumFilename, 'w')
    checksumFile.write(str(checksum))
    checksumFile.close()

    message = "Written checksum %s to file %s \n" % (checksum, checksumFilename)
    return message

def sendEmail(TO, FROM, message, smtpserver="localhost", attFileFullPath=None):
    global hostname

    msg = MIMEMultipart('alternative')
    msg["From"] = FROM
    msg["To"] = TO
    msg["Subject"] = "%s - File report for %s." % (hostname, filename)
    msg['Date']    = formatdate(localtime=True)
    msg.preamble = message

    messagehtml = str(message).replace("\n", "<br />")
    messagehtml = str(messagehtml).replace("=== ", "<strong>")
    messagehtml = str(messagehtml).replace(" ===", "</strong>")
    messagehtml = str(messagehtml).replace("Checksum does NOT match.", "<font color = \"red\">Checksum does NOT match.</font>")
    messagehtml = str(messagehtml).replace("Checksum matches.", "<font color = \"green\">Checksum matches.</font>")

    part1 = MIMEText(message, 'plain')
    part2 = MIMEText(messagehtml, 'html')
    msg.attach(part1)
    msg.attach(part2)

    if attFileFullPath != None:
        # attach a file
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(attFileFullPath,"rb").read() )
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % attFileFullPath)
        msg.attach(part)
 
    server = smtplib.SMTP(smtpserver)
    # server.login(username, password)  # optional
 
    try:
        failed = server.sendmail(FROM, TO, msg.as_string())
        server.close()
        return "Mail sent."
    except:
        errorMsg = "Unable to send email."
        return errorMsg


result = compare_checksum(filename, checksum_compare, overwrite_checksum)

sendthemail = False

if matches == 1 and mail_on_match == True:
    sendthemail = True

if matches == 0:
    sendthemail = True

if sendthemail == True:
    if attach_file == True:
        try:
            sendEmail(mail_to, mail_from, result, smtp_server, abspath)
        except socket.error, e:
            print "Error: mail could not be sent: ", e
    else:
        try:
            sendEmail(mail_to, mail_from, result, smtp_server)
        except socket.error, e:
            print "Error: mail could not be sent: ", e

    
