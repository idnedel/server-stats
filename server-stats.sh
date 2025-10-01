#!/bin/bash

echo "==== Server Monitor ===="

#CPU data
read cpu user nice system idle iowait irq softirq steal guest guest_nice < <(grep "cpu " /proc/stat)

CpuTotal=$((user + nice + system + idle + iowait + irq + softirq + steal))
CpuUsed=$((user + nice + system + irq + softirq + steal))

CpuData=$((100 * CpuUsed / CpuTotal))

#Memory data
while read label total used free shared buff_cache available; do
	if [[ $label == "Mem:" ]]; then
		MemTotal=$total
		MemUsed=$used
		MemFree=$free
		MemAvailable=$available
		break
	fi
done < <(free -m)

MemUsageData=$((100 * MemUsed / MemTotal))
MemFreeData=$((100 * MemFree / MemTotal))

#Disk data

echo "Total CPU usage: $CpuData%"
echo "Total memory usage - Used: $MemUsageData% / Free: $MemFreeData%"
#echo "Total disk usage - Used: / Free: "
#echo "Top 5 process by CPU usage: "
#echo "Top 5 process by memory usage: "

