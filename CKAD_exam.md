## Exam  prep:
- Login with Google Auth:
- [LinuxFoundation login](https://trainingportal.linuxfoundation.org/learn/course/certified-kubernetes-application-developer-ckad/exam/exam)
- [Exam schedule](https://www.examslocal.com/)
- [Exam requirment](https://www.examslocal.com/#)
- [Details](https://www.examslocal.com/ScheduleExam/Payment)
- Sri laptop
- install plugins
- Primary and Secondary id for id PRoof.
- Webcam should be available 
- [Check before Exam](https://trainingportal.linuxfoundation.org/learn/course/certified-kubernetes-application-developer-ckad/exam/exam)

- https://kubernetes.io/docs/, https://github.com/kubernetes/,  https://kubernetes.io/blog/ are accessed
- https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad
- sudo -i for admin commands
- alias ctc='export KUBECONFIG=/root/kc/CTC/.kube/config;export CLU=CTC'
- Set the default namespace kubectl config set-context $(kubectl config current-context) --namespace=dev
- kubectl explain pod --recursive|more
- k run webapp --image=nginx --labels="tier=frontend" --replicas=2
- k expose deployment webapp --name=frontend --type=Nodeport --target-port=80 --port=80 --dry-run -o yaml
- k get pod testpod -o yaml --export -----will give basic yaml file
-  k explain pv --recursive|grep -A5 hostPath

### Pod
- apiVersion sholud be v1 and kind should be Pod.
- Containers may have more than one hence those should be mentioned as lists
- Metadata are dic
- k run <pod name> --image=nginex:1.16 
- Syntax : kubectl run NAME --image=imge [--env="key=value"] [--port=port] [--dry-run=server|client] [--overrides=inline-json]
[--command] -- [COMMAND] [args...] [options]
- k explain pod --recursive will get more details.
- k run --help 
- kubectl create -f ./pod.json
  

```
apiVersion: v1
kind: Pod
metadata:
  name: firstpod
  labels:
     app: firstapp
     type: frontend
spec:
  containers: 
    - name: firstcontainer
      image: nginx
```
