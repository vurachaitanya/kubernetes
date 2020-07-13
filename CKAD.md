# CKAD Exam prep

## Services :
- equality-based :
Filters by label keys and their values. Three operators can be used, such as =, ==, and !=. If multiple values or keys are used, all must be included for a match.
- set-based :
Filters according to a set of values. The operators are in, notin, and exists. For example, the use of status notin (dev, test, maint) would select resources with the key of status which did not have a value of dev, test, nor maint.

## 1 IP per Pod
- Containers X and Y Containers share the network namespace of a third container, known as the pause container. The pause container is used to get an IP address, then all the containers in the pod will use its network namespace. You won’t see this container from the Kubernetes perspective, but you would by running sudo docker ps
- To communicate with each other, containers can use the loopback interface, write to files on a common filesystem, or via inter-process communication (IPC). As a result, co-locating applications in the same pod may have issues. There is a network plugin which will allow more than one IP address, but so far, it has only been used within HPE labs.
- Support for dual-stack, IPv4 and IPv6 continues to increase with each release. For example, in a recent release kube-proxy iptables supports both stacks simultaneously.
- [Reff link for Networking Model](https://speakerdeck.com/thockin/illustrated-guide-to-kubernetes-networking)
- [Reff link for Networking in details](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
- [Google Borg K8s podcast voice](https://www.gcppodcast.com/post/episode-46-borg-and-k8s-with-john-wilkes/)
- [First StackOverflow update by me](https://stackoverflow.com/questions/56800733/openshift-3-11-edit-deployment-config-cant-add-command/62865744#62865744)

### Sample ReplicationController yml file
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
  namespace: chaitudemo
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.0-debian-9
        ports:
        - containerPort: 80

```
### Sample ReplicaSet yml
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: grafana
  namespace: chaitudemo
spec:
  replicas: 3
  selector:
    matchLabels:
      df: gf
  template:
    metadata:
      name: grafanapod
      labels:
        df: gf
    spec:
      containers:
        - name: grafanacon
          image: grafana:latest

```
### Sample ReplicationController deplyments
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: abc1
  namespace: chaitudemo
spec:
  replicas: 3
#  selector:
#    app: test
  template:
    metadata:
      name: grafanapod
      labels:
        app: test
    spec:
      containers:
        - name: grafanacon
          image: grafana:latest

```
### Sample pod deployment 
```
apiVersion: v1
kind: Pod
metadata:
  name: testpod3
  namespace: chaitudemo
spec:
  containers:
   - name: chaitucont
     image: nginx:1.14.0-debian-9
   - name: chaitugrafana
     image: grafana:latest

```
### Deployments Sample yml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chaitudep3
  namespace: chaitudemo
spec:
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      name: chaitudepl1
      labels:
        app: test
    spec:
      containers:
        - name: nginex
          image: grafana:latest
  replicas: 3
```
### Note : Lessons learnt from sample deployment files are 
- Selector and matchlabels should be present at Deployments/ ReplicationController / Replicationset resources. And lables should be present in template so as to start monitored by above resources.

- If you simply want to test your command, use the --dry-run=client option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.
- -o yaml: This will output the resource definition in YAML format on the screen.
### POD Create an NGINX Pod
```
kubectl run nginx --image=nginx
```
### Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)
```
kubectl run nginx --image=nginx  --dry-run=client -o yaml
```
### Deployment: Create a deployment
```
kubectl create deployment --image=nginx nginx
```
### Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)
```
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
```
### kubectl create deployment does not have a --replicas option. You could first create it and then scale it using the kubectl scale command.

- kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

- You can then update the YAML file with the replicas or any other field before creating the deployment.

