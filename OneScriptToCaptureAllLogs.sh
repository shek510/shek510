ProcessID=`ps -ef | grep java | grep cartengine | grep -v grep | awk '{ print $2}'`
Time=`date +%F-%H-%M-%S`
IP=`hostname -i | awk '{ print $2 }'`
mkdir -p /tmp/Debug/$Time/lsof/
mkdir -p /tmp/Debug/$Time/tcpdump/
mkdir -p /tmp/Debug/$Time/strace/
mkdir -p /tmp/Debug/$Time/netstat/
mkdir -p /tmp/Debug/$Time/jstack
mkdir -p /tmp/Debug/$Time/jfr
mkdir -p /tmp/Debug/$Time/heapdump
chmod -R 777 /tmp/Debug/$Time/
sudo yum install -y strace
sudo yum install -y tcpdump
sudo yum install -y lsof
for i in {1..300}; do (sudo -su serviceadmin jstack $ProcessID > /tmp/Debug/$Time/jstack/jstack_$i_$(date +%F-%H-%M-%S); sleep 1); done &
for i in {1..300}; do (sudo -su serviceadmin lsof -Pnp $ProcessID > /tmp/Debug/$Time/lsof/lsof_$i_$(date +%F-%H-%M-%S); sleep 1); done &
for i in {1..300}; do (sudo netstat -nalp > /tmp/Debug/$Time/netstat/netstat_$i_$(date +%F-%H-%M-%S); sleep 1); done &
sudo tcpdump -i any host $IP -n -s 0 -vvv -w /tmp/Debug/$Time/tcpdump/$(hostname)_$(date +%F-%H-%M-%S).pcap > /dev/null 2>&1 &
sudo -su serviceadmin jcmd $ProcessID VM.unlock_commercial_features
sudo -su serviceadmin jcmd $ProcessID JFR.start duration=280s filename=/tmp/Debug/$Time/jfr/jfr_$(date +%F-%H-%M-%S).jfr
sudo -su serviceadmin jmap -dump:live,format=b,file=/tmp/Debug/$Time/heapdump/heap.hprof $ProcessID &
sudo strace -ffo /tmp/Debug/$Time/strace/$(hostname)_$(date +%F-%H-%M-%S) -s 3000 -Tttqp $ProcessID &
sleep 310
starcePID=`ps -ef | grep strace | grep -v grep | awk '{ print $2}'`
tcpdumpPID=`ps -ef | grep tcpdump | grep -v grep | awk '{ print $2}'`
sudo kill -9 $starcePID
sudo kill -9 $tcpdumpPID