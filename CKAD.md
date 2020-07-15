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
### Ways of declaring them :

- ENV
```
envFrom:
   - secretRef:
       name: app-config
 ```
 - Single Env:
 ```
 env:
    - name: DB_Password
      valueFrom:
         secretKeyRef:
            name: app-secret
            key: DB_Password
 ```
 - Volume: Inside the volume files/volumes are created ls /opt/app-secret-volumes if 3 valuse are defined 3 volumes are mounted
 ```
 volumes:
 - name: app-secret-volume
   secret:
      secretName: app-secret
 ```
 ```
 #kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root  --from-literal=DB_Password=password123 --dry-run=client -o yaml
------OUTPUT---------
apiVersion: v1
data:
  DB_Host: c3FsMDE=
  DB_Password: cGFzc3dvcmQxMjM=
  DB_User: cm9vdA==
kind: Secret
metadata:
  creationTimestamp: null
  name: db-secret
 ```
- Also the way kubernetes handles secrets. Such as:

    * A secret is only sent to a node if a pod on that node requires it.
    * Kubelet stores the secret into a tmpfs so that the secret is not written to disk storage.
    * Once the Pod that depends on the secret is deleted, kubelet will delete its local copy of the secret data as well.
    * Read about the protections and risks of using secrets here

- Other better ways of handling sensitive data like passwords in Kubernetes, such as using tools like Helm Secrets, HashiCorp Vault.

- All the capability of OS are defined in `ls -l /usr/include/linux` and few are used by Dockers/Containers:
```
# ls|grep name
net_namespace.h
utsname.h
```
- Docker by default run as root to avoide security `docker run --user=1001 ubuntu sleep 2000`
- Docker Capabilities can be added to a container/Docker by `docker run --cap-add MAC_ADMIN ubuntu` and drop by using `docker run --cap-drop KILL ubuntu`
- Add all privilages by  `docker run --privileged ubuntu`

### Security Context :
- Container level security Context
```
apiVersion: v1
kind: Pod
metadata:
   name: web-pod
spec:
  containers: 
     - name: ubuntu
       image: ubuntu
       command: ["sleep", "3600"]
       securityContext:
         runAsUser: 1000
         capabilities:
            add: ["MAC_ADMIN"]
```
- Pod level security Context
```
apiVersion: v1
kind: Pod
metadata:
   name: web-pod
spec:
  securityContext:
     runAsUser: 1000
  containers: 
     - name: ubuntu
       image: ubuntu
       command: ["sleep", "3600"]    
```
- SecurityContext
```
piVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  securityContext:
    runAsUser: 1001
  containers:
  -  image: ubuntu
     name: web
     command: ["sleep", "5000"]
     securityContext:
      runAsUser: 1002

  -  image: ubuntu
     name: sidecar
     command: ["sleep", "5000"]
```
- Now try to run the below command in the pod to set the date. If the security capability was added correctly, it should work. If it doesn't make sure you changed the user back to root `date -s '19 APR 2012 11:14:00`

```
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper
  namespace: default
spec:
  containers:
  - command:
    - sleep
    - "4800"
    image: ubuntu
    imagePullPolicy: Always
    command: ["date"]
    args: ["-s", "19 APR 2012 11:14:00"]
    name: ubuntu
    securityContext:
      capabilities:
         add: ["SYS_TIME"]
```
### Serviceaccounts: 
- Creating SA using below command:

` kubectl create serviceaccount dashboard-sa`
- to display SA
` k get serviceaccount`
- Details about SA
`k describe sa dashboard-sa`
- Secrets about SA:
`k describe secret dashboard-sa-token-kbbda`
- Curl command to get the k8s details
```
curl https://192.168.1.2:6443/api -nosecure --header “Authorization: Bearer x34ve>4fv”
K describe pod xxxx|grep secrets  (Volume is mounted as secrets for accessin the pods)
```
```
Spec:
  serviceAccount: dashboard-sa  -----> For pod to use SA rather than using default SA
  automountServiceAccountToken: false -----> not to use default SA token 
```

```
master $ cat dashboard-sa-role-binding.yaml
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:- kind: ServiceAccount
  name: dashboard-sa # Name is case sensitive
  namespace: default
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

```
master $ cat pod-reader-role.yaml
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups:
  - ''
  resources:
  - pods
  verbs:
  - get
  - watch
  - list
```


## Resources Limits:

### Cpu : 
-	1m (0.1 milli cores ) is the min 
-	1 (1000 Milli Cores) equal to AWS vCPU, 1 GCP core, 1 Azure Core, 1 Hyperthread

### Memory: 
-	256 Mi
-	24534343
-	1G
-	Units for Memory:
-	1 G(GigaByte) = 1,000,000,000 bytes
-	1M(Megabyte)= 1,000,000 bytes
-	1K(Kilobyte) = 1,000 bytes
-	1 Gi(Gibibyte) = 1,073,741,824 bytes
-	1 Mi(Mebibyte) = 1,048,576 bytes
-	1 Ki(kibibyte) = 1024 bytes

```
apiVersion: v1
kind: Pod
metadata: 
   name: webapp-color
   labels:
      name: webapp-color
spec:
   containers:
   - name: webapp-color
     image:  simple-webapp-color
     ports:
     - containerPorts: 8080
     resources:
       requests:
         memory: “1Gi”
         cpu: 1
       limits:
         memory: “2Gi”
         cpu: 2
```

### Limit Range:
- In the previous lecture, I said - "When a pod is created the containers are assigned a default CPU request of .5 and memory of 256Mi". For the POD to pick up those defaults you must have first set those as default values for request and limit by creating a LimitRange in that namespace.

- [Default memory limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/)
- [Default cpu limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/)
- Sample Limit range files which can be defined for a namespaces.

```
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
```

```
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-limit-range
spec:
  limits:
  - default:
      cpu: 1
    defaultRequest:
      cpu: 0.5
    type: Container
```
- create stress vm which will have memory issues while creating the pods if mem=10Mi
```
apiVersion: v1
kind: Pod
metadata:
    name: elephant
    namespace: default
spec:
    containers:
    - args:
      - --vm
      - "1"
      - --vm-bytes
      - 15M
      - --vm-hang
      - "1"
      command:
      - stress
      image: polinux/stress
      imagePullPolicy: Always
      name: mem-stress
      resources:
        limits:
          memory: 20Mi
        requests:
          memory: 5Mi
```

## Exam prep:

[kubectl command reff](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#expose)
- set the alias k=kubectl so as to save time.

```

kubectl config set-context mycontext –namespace=mynamespace  ----> set the default namespace so as to not sepcify -n <namespace>
kubectl explain cronjob.spec.jobTemplate –recursive -----> examples of cronjob syntax / Templates

kubectl run nginx --image=nginx   (deployment)
kubectl run nginx --image=nginx --restart=Never   (pod)
kubectl run nginx --image=nginx --restart=OnFailure   (job)  
kubectl run nginx --image=nginx  --restart=OnFailure --schedule="* * * * *" (cronJob)

kubectl run nginx -image=nginx --restart=Never --port=80 --namespace=myname --command --serviceaccount=mysa1 --env=HOSTNAME=local --labels=bu=finance,env=dev  --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi' --dry-run -o yaml - /bin/sh -c 'echo hello world'

kubectl run frontend --replicas=2 --labels=run=load-balancer-example --image=busybox  --port=8080
kubectl expose deployment frontend --type=NodePort --name=frontend-service --port=6262 --target-port=8080
kubectl set serviceaccount deployment frontend myuser
kubectl create service clusterip my-cs --tcp=5678:8080 --dry-run -o yaml
```

## Taints & tolerations: 
`k taint nodes node-name key=value:taint-effect`
- Taints are applyed to a node
- Tolerations applyed to pods
- taint-effect:
  * NoSchedule – No Pods are scheduled on this node
  * PreferNoSchedule – Will try not to scheduled on to this node
  * NoExecute – Existing pods will be evacuated if it is not tolerant 

`EX: k taint node node1 app=blue:NoSchedule`

```
apiVersion: v1
kind: Pod
metatadata:
  name: myapp-pod
spec: 
  containers:
- name: nginx-container
  image: nginx
  tolerations:
     - key: “app”
       operator: “Equal”
       value: “blue “
       effect:”NoSchedule”
```
