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

## Cheetsheet

- [Exam tips and hints](https://github.com/dgkanatsios/CKAD-exercises)
- `kubectl explain Pod.spec.containers.livenessProbe` will share the detials of liveness proble commands and its options
- sudo -i for admin commands
- alias ctc='export KUBECONFIG=/root/kc/CTC/.kube/config;export CLU=CTC'
- Set the default namespace kubectl config set-context $(kubectl config current-context) --namespace=dev
- kubectl explain pod --recursive|more
- k run webapp --image=nginx --labels="tier=frontend" --replicas=2
- k expose deployment webapp --name=frontend --type=Nodeport --target-port=80 --port=80 --dry-run -o yaml
- k get pod testpod -o yaml --export -----will give basic yaml file
- k explain pv --recursive|grep -A5 hostPath
- k api-resources|grep -i replicationcontroller

### Speed aliases:
```
alias k='kubectl'
alias kd='kubectl describe'
alias kr='kubectl run'
alias kc='kubectl create'
alias ke='kubectl explain --recursive'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
```
### Short names:
```
NAME------>SHORTNAMES
componentstatuses------>cs
configmaps------>cm
endpoints------>ep
events------>ev
limitranges------>limits
namespaces------>ns
nodes------>no
persistentvolumeclaims------>pvc
persistentvolumes------>pv
pods------>po
replicationcontrollers------>rc
resourcequotas------>quota
serviceaccounts------>sa
services------>svc
customresourcedefinitions------>crd,crds
daemonsets------>ds
deployments------>deploy
replicasets------>rs
statefulsets------>sts
horizontalpodautoscalers------>hpa
cronjobs------>cj
jobs------>batch
certificatesigningrequests------>csr
events------>ev
ingresses------>ing
networkpolicies------>netpol
poddisruptionbudgets------>pdb
podsecuritypolicies------>psp
priorityclasses------>pc
storageclasses------>sc
```
### Command explain/ Helping tools :
- Kubectl help `kubectl run --help`
- explain the ojbects of the resources `k explain pods`
- explain with resources/ojbects/variables used `k explain pod --recursive`
- [K8s documentation cheetsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)


### Imperative commands:

- Create Pods:  `kubectl run hello-pod --image=nginx --restart=Never --dry-run=client -o yaml > hello-pod.yaml`
- Expose a pod (using a service and specifying ports and service type): `kubectl expose po hello-pod --port=80 --target-port=9376 --type=NodePort`
- Create Deployments: ` kubectl create deploy hello-deploy --image=nginx --dry-run=client -o yaml > hello-deploy.yaml`
- Update deployment image to nginx:1.17.4: `kubectl set image deploy/hello-deploy nginx=nginx:1.17.4`
- Scale a deployment:  `kubectl scale deploy hello-deploy --replicas=20`
- Create Jobs:  `kubectl create job hello-job --image=busybox --dry-run=client -o yaml -- echo "Hello I am from job" > hello-job.yaml`


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

## ReplicationController:

- For each teamplate of pod label is required and matchlabel is optional

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: samplers
spec:
  template:
    metadata:
      name: rc-pod 
      labels: ## selector is take by default if not specified also need to give labels in pod defination
        app: test
    spec:
      containers:
       - name: rc-container
         image: nginx
  replicas: 3

```

## ReplicaSet:

- Diff b/w replicationcontroller vs replicaset are
   * Need to have matchLable must for replicaset
   * replicationcontroller apiVersion: v1 & replicaSet apiVersion = apps/v1
- Scaling pods in replicaSet
   * update the configfile with desired replicas and use ` k replace -f <config file>`
   * same file with replicas in command line  `k scale --replicas=6 -f <Config file>`
   * commandline `k scale --replicas=6 replicaset <replicaset name>`
   
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: samplers
spec:
  template:
    metadata:
      name: rs-pod
      labels:
        app: test1
    spec:
      containers:
       - name: rc-container
         image: nginx
  replicas: 3
  selector:
    matchLabels:
      app: test1

```
