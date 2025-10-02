#!/bin/bash

echo "==== Server Monitor ===="
echo " "

#CPU data
read cpu user nice system idle iowait irq softirq steal guest guest_nice < <(grep "cpu " /proc/stat)

CpuTotal=$((user + nice + system + idle + iowait + irq + softirq + steal))
CpuUsed=$((user + nice + system + irq + softirq + steal))

CpuData=$((100 * CpuUsed / CpuTotal))

#Memory data
read label MemTotal MemUsed MemFree shared buff_cache MemAvailable <<< $(free -m | grep 'Mem:')

MemUsageData=$((100 * MemUsed / MemTotal))
MemFreeData=$((100 * MemFree / MemTotal))

#Disk data
read Filesystem DiskTotal DiskUsed DiskAvail DiskUsePercent Mounted <<<$(df / | awk 'NR==2')

DiskUsageData=$((100 * DiskUsed / DiskTotal))
DiskAvailData=$((100 * DiskAvail / DiskTotal))

#CPU process data
CpuProcessData=$(ps -eo pid,%cpu,comm,cmd --sort=-%cpu | head -n 6)

#Memory process data
MemProcessData=$(ps -eo pid,%mem,comm,cmd --sort=-%mem | head -n 6)


echo ">>> CPU"
echo "Total CPU usage: $CpuData%"
echo " "
echo " "

echo ">>> MEMORY"
echo "Total memory usage - Used: $MemUsageData% / Free: $MemFreeData%"
echo " "
echo " "

echo ">>> DISK"
echo "Total disk usage - Used: $DiskUsageData% / Free: $DiskAvailData%"
echo " "
echo " "

echo ">>> CPU - TOP 5 PROCESSES"
echo "Top 5 process by CPU usage:"
echo "$CpuProcessData"
echo " "
echo " "

echo ">>> MEMORY - TOP 5 PROCESSES"
echo "Top 5 process by memory usage:"
echo "$MemProcessData"
echo " "
echo " "
