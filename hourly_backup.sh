#!/bin/bash
DATE=`date +%Y-%m-%d-%H-%M`
DATE2=`date +%Y-%m-%d`
DATEBACK_HOUR=`date --date='6 days ago' +%Y-%m-%d`
DATEBACK_DAY=`date --date='60 days ago' +%Y-%m-%d`
FLAGS="--archive --verbose --numeric-ids --delete --rsh='ssh'"
BACKUP_DRIVE="/storage"
DAY_USB_DRIVE="/backup_daily"
HOUR_USB_DRIVE="/backup_hourly"

# RSync Information
rsync_info[1]="beryllium.niden.net html rsync"
rsync_info[2]="beryllium.niden.net db rsync"
rsync_info[3]="nitrogen.niden.net html rsync"
rsync_info[4]="nitrogen.niden.net html db"
rsync_info[5]="nitrogen.niden.net html svn"
rsync_info[6]="argon.niden.net html rsync"

# RSync Source Folders
rsync_source[1]="beryllium.niden.net:/var/www/localhost/htdocs/"
rsync_source[2]="beryllium.niden.net:/niden_backup/db/"
rsync_source[3]="nitrogen.niden.net:/var/www/localhost/htdocs/"
rsync_source[4]="nitrogen.niden.net:/niden_backup/db"
rsync_source[5]="nitrogen.niden.net:/niden_backup/svn"
rsync_source[6]="argon.niden.net:/var/www/localhost/htdocs/"

# RSync Target Folders
rsync_target[1]="beryllium.niden.net/html/"
rsync_target[2]="beryllium.niden.net/db/"
rsync_target[3]="nitrogen.niden.net/html/"
rsync_target[4]="nitrogen.niden.net/db/"
rsync_target[5]="nitrogen.niden.net/svn/"
rsync_target[6]="argon.niden.net/html/"

# GZip target files
servers[1]="beryllium.niden.net"
servers[2]="nitrogen.niden.net"
servers[3]="argon.niden.net"

echo "BACKUP START"  &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
date  &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log

echo "BACKUP START"  &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
date  &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log

# Loop through the RSync process
element_count=${#rsync_info[@]}
let "element_count = $element_count + 1"
index=1
while [ "$index" -lt "$element_count" ]
do
    echo ${rsync_info[$index]} &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    rsync $FLAGS ${rsync_source[$index]} $BACKUP_DRIVE/${rsync_target[$index]} &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log</pre>
<pre class="brush:bash">    let "index = $index + 1"
done

# Looping to GZip data
element_count=${#servers[@]}
let "element_count = $element_count + 1"
index=1
while [ "$index" -lt "$element_count" ]
do
    echo "GZip ${servers[$index]}" &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    tar cvfz $BACKUP_DRIVE/${servers[$index]}-$DATE.tgz $BACKUP_DRIVE/${servers[$index]} &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    let "index = $index + 1"
done

# Looping to copy the produced files (if applicable) to the daily drive
element_count=${#servers[@]}
let "element_count = $element_count + 1"
index=1

while [ "$index" -lt "$element_count" ]
do
    # Copy the midnight files
    echo "Removing old daily midnight files" &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    rm -f $DAY_USB_DRIVE/${servers[$index]}/${servers[$index]}-$DATEBACK_DAY*.* &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    echo "Copying daily midnight files" &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    cp -v $BACKUP_DRIVE/${servers[$index]}-$DATE2-00-*.tgz $DAY_USB_DRIVE/${servers[$index]}  &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    rm -f $BACKUP_DRIVE/${servers[$index]}-$DATE2-00-*.tgz &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log

    # Now copy the files in the hourly
    echo "Removing old hourly files" &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    rm -f $HOUR_USB_DRIVE/${servers[$index]}/${servers[$index]}-$DATEBACK_HOUR*.* &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    echo "Copying daily midnight files" &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    cp -v $BACKUP_DRIVE/${servers[$index]}-$DATE.tgz $HOUR_USB_DRIVE/${servers[$index]} &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    rm -f $HOUR_USB_DRIVE/${servers[$index]}/${servers[$index]}-$DATEBACK*.* &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
    let "index = $index + 1"
done

echo "BACKUP END"  &gt;&gt; $BACKUP_DRIVE/logs/$DATE.log
