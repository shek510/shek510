for i in $(seq 1 1 400)
do
var=`date +%d-%m-%Y_T%H-%M-%S`
echo $var >> /tmp/Timestampms0g5.txt
kubectl exec --stdin --tty messaging-pod-prod-gcp-6dbbc569f-4xxwc -- jcmd 7 JFR.start duration=900s filename=/tmp/ProdJFR/JfrRecordingFile_messaging-pod-prod-gcp-6dbbc569f-4xxwc_gcpraomsapp05_$var.jfr
sleep 901
done
