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

### Service : Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379
```
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml
```
- This will automatically use the pod's labels as selectors
OR
```
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml 
```
- This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service


- Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:
```
kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml
```
- This will automatically use the pod's labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.

```
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml
```
- This will not use the pods labels as selectors

- Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the `kubectl expose` command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.

[Reff link for more command line details](https://kubernetes.io/docs/reference/kubectl/conventions/)

### Sample deployment file parsing command line 
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-1
spec:
  replicas: 2
  selector:
    matchLabels:
      name: busybox-pod
  template:
    metadata:
      labels:
        name: busybox-pod
    spec:
      containers:
      - name: busybox-container
        image: busybox888
        command:
        - sh
        - "-c"
        - echo Hello Kubernetes! && sleep 3600
```

### Here are some of the commonly used formats: 
- [K8s_details](https://kubernetes.io/docs/reference/kubectl/overview/)
- [K8s_cheetsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

```
-o jsonOutput a JSON formatted API object.

-o namePrint only the resource name and nothing else.

-o wideOutput in the plain-text format with any additional information.

-o yamlOutput a YAML formatted API object.
```
- Set the default namespace `kubectl config set-context $(kubectl config current-context) --namespace=dev`

- Create a pod called httpd using the image httpd:alpine in the default namespace. Next, create a service of type ClusterIP by the same name (httpd). The target port for the service should be 80.
- Solution:  `kubectl run httpd --image=httpd:alpine --port=80 --expose`


### Docker vs K8s 
-	Docker
```
FROM ubuntu
ENTRYPOINT[“sleep”]
CMD[“5”]
```
-	K8s:
```
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleep-pod
spec:
  containers:
   - name: ubuntu-sleep
     image: ubuntu-sleep
       command: [“sleep”]
       args: [“10”]
```
## Editing pods and Deploymentes :

- Edit a POD : Remember, you CANNOT edit specifications of an existing POD other than the below.

`spec.containers[*].image`

`spec.initContainers[*].image`

`spec.activeDeadlineSeconds`

`spec.tolerations`

- For example you cannot edit the environment variables, service accounts, resource limits (all of which we will discuss later) of a running pod. But if you really want to, you have 2 options:
   * Run the kubectl edit pod <pod name> command.  This will open the pod specification in an editor (vi editor). Then edit the required properties. When you try to save it, you will be denied. This is because you are attempting to edit a field on the pod that is not editable.
   * The second option is to extract the pod definition in YAML format to a file using the command `kubectl get pod webapp -o yaml > my-new-pod.yaml` Then make the changes to the exported file using an editor (vi editor). Save the changes and deleted and create pod using above template file.

- Edit Deployments :
 With Deployments you can easily edit any field/property of the POD template. Since the pod template is a child of the deployment specification,  with every change the deployment will automatically delete and create a new pod with the new changes. So if you are asked to edit a property of a POD part of a deployment you may do that simply by running the command `kubectl edit deployment my-deployment`

###  ConfigMaps: 

-  Imperative (Command mode) :
` kubectl create configmap app-config –from-literal=APP_COLOR=blue –from-literal:APP_MOD=prod `
` kubectl create configmap app-config –from-file=app_config.properties `


- Declarative (File mode) :

```
# cat Config-map.yaml
appVersion: v1
kind: ConfigMap
metadata:
  name:app-config
data:
   APP_COLOR: blue
   APP_MODE: prod
```
- Sample ConfigMap used in pods:
```
apiVersion: v1
kind: Pod
metadata:
   name: sample-webapp-color
   labels:
      name: sample-webapp-color
spec:
  containers:
-	name: sample-webapp-color
  image: sample-webapp-color
  ports:
    - containerPort: 8080
  envFrom:
    - configMapRef:
        name: app-config
```

### Sample ConfigMap in pods Def:
- ENV
```
envFrom:
-	configMapRef:
    name:app-config
```
- Single Env:
```
env:
  - name: APP_COLOR
  valueFrom:
     configMapKeyRef:
       name: app-config
       key: APP_COLOR
```
- Volume

```
volumes:
  - name: app-config-vol
    configMap:
      name: app-config
```
- Webapp for color change
```
apiVersion: v1
kind: Pod
metadata:
    labels:
      name: webapp-color
    name: chaituapp
    namespace: default
spec:
    containers:
    - env:
      - name: APP_COLOR
        value: pink
      image: kodekloud/webapp-color
      name: webapp-color
```

### Secrets :

- Imperative:
 `Kubectl create secret generic app-secret –from-literal=DB_Host=mysql –from-literal=DB_User=root –from-literal=DB_Password=passwd`
 
- From filelocation:
`Kubectl create secret generic app-secret –from-file=app_secret.properties`

- Declarative :
```
apiVersion: v1
kind: Secret
metadata:
   name: app-secret
data: 
   DB_Host: mysql
   DB_User: root
   DB_Password: paswrd
```
 - kubectl create -f secret-data.yml to create Secret from Declarative mode
`echo -n “mysql”|base64`
`echo -n “bXlzcWw=”|base64 --decode`

### Sample  Secret used in pod file:
```
apiVersion: v1
kind: Pod
metadata:
   name: sample-webapp-color
   labels:
      name: sample-webapp-color
spec:
  containers:
    - name: sample-webapp-color
      image: sample-webapp-color
      ports:
        - containerPort: 8080
      envFrom:
        - secretRef:
            name: app-secret
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
   DB_Host: bXlzcWw=
   DB_User: adef3b32$
   DB_Password: e3g33vw3-
```
