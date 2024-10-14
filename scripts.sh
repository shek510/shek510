timefilename=`date +%F-%H-%M-%S`
src_dir="/tmp/PT_Monitoring/$timefilename"
mkdir -p $src_dir
mkdir -p "$src_dir/Strace"
mkdir -p "$src_dir/TCPDump"
ProcessID=`ps -ef | grep java | grep -i Xmx2g | grep appapis | grep -v grep | awk '{ print $2}'`
sudo strace -ffo $src_dir/Strace/Strace_$(hostname) -s 10000 -Tttqp $ProcessID &
sudo tcpdump -i any host 10.167.248.232 -w $src_dir/TCPDump/Tcp_$(hostname).pcap &
sleep 6
starcePID=`ps -ef | grep strace | grep -v grep | awk '{ print $2}'`
sudo kill -9 $starcePID
tcpdumpPID=`ps -ef | grep tcpdump | grep -v grep | awk '{ print $2}'`
sudo kill -9 $tcpdumpPID
count=`grep -rnw "Could not open JDBC Connection for transaction" $src_dir/Strace/* | wc -l`
if [ "$count" -eq 0 ];
then
rm -rf "$src_dir"
fi


for i in $(seq 1 1 20)
do
timefilename=`date +%F-%H-%M-%S`
src_dir="/tmp/PT_Monitoring/$timefilename"
mkdir -p $src_dir
mkdir -p "$src_dir/TCPDump"
ProcessID=`ps -ef | grep java | grep -i Xmx12g | grep appapis | grep -v grep | awk '{ print $2}'`
sudo tcpdump -i any host 10.167.248.232 -w $src_dir/TCPDump/Tcp_$(hostname).pcap &
sleep 60
tcpdumpPID=`ps -ef | grep tcpdump | grep -v grep | awk '{ print $2}'`
sudo kill -9 $tcpdumpPID
done
