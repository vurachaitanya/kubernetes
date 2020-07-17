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

### Node Selector:

- Labels the node and based on the node label the pod should be deployed.

`k label node node01 size=Large`

- Node selector based on the Labels of the node


```
apiVersion: v1
kind: Pod
metadata: 
   name: nodeSelector
spec:
  containers:
     - name: sampleNodeSelector
	   image: nginex
  nodeSelector:
      size: Large
```

### Node Affinity:

- Node selector can't be used if size != or in Medium/Small etc
- So more operatoers can be used in Node Affinity
```
apiVersion: v1
kind: Pod
metadata: 
   name: nodeSelector
spec:
  containers:
     - name: sampleNodeSelector
	   image: nginex
  affinity:
    nodeAffinity:
	  requiredDuringSchedulingIgnoredDuringExecution:
	    nodeSelectorTerms:
		  - matchExpressions:
		    - key: Size
			  operator: In
			  values:
			  - Large
			  - Medium
			  
			  
			  - key: Size
			    operator: NotIn
				values:
				 - Small
				 
			  - key: Size
			    operator: Exists
```

### Types of Node Affinity:

- Available:
   * requiredDuringSchedulingIgnoredDuringExecution
   * preferredDuringSchedulingIgnoredDuringExecution
- Planned: (Will move the pods/ Pod evection, if the label is removed at later part)
   * requiredDuringSchedulingRequiredDuringExecution
   
- During Scheduling
- During Execution

### Label nodes
`k label node node01 color=blue`

### Node Affinity :

- Set Node Affinity to the deployment to place the PODs on node01 only
```
Name: blue
Replicas: 6
Image: nginx
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
Key: color
values: blue
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: blue
  name: blue
spec:
  replicas: 6
  selector:
    matchLabels:
      app: blue
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: blue
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        nodeAffinity:
         requiredDuringSchedulingIgnoredDuringExecution:
           nodeSelectorTerms:
            - matchExpressions:
                - key: color
                  operator: In
                  values:
                   - blue
```

- Create a new deployment named 'red' with the NGINX image and 3 replicas, and ensure it gets placed on the master node only.
   * Use the label - node-role.kubernetes.io/master - set on the master node.

```
Name: red
Replicas: 3
Image: nginx
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
Key: node-role.kubernetes.io/master
Use the right operator
```

```
piVersion: apps/v1
kind: Deployment
metadata:
  name: red
spec:
  replicas: 3
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists
```
### Exam Tips: 

- [Linkedin](https://www.linkedin.com/pulse/my-ckad-exam-experience-atharva-chauthaiwale/)
- [Medium](https://medium.com/@harioverhere/ckad-certified-kubernetes-application-developer-my-journey-3afb0901014)
- [Git](https://github.com/lucassha/CKAD-resources)

### Multi-Container in pods
- Types of multi Container
   * Sidecar
   * Adapter
   * Ambassador
- Sidecar to have same network and volumea across containers. Ex: nginx logs --> long management 
- Adapter containers dose some logic to convert logs in required format or send database requests based on the envrionments etc.
- Containers are defined in a list of pod templates so as to add 2 or more containers in a pod.

- Pod creation with volume logs stored in file system.

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: app
  name: app1
  namespace: elastic-stack
spec:
  containers:
  - image: kodekloud/event-simulator
    imagePullPolicy: Always
    name: app
    volumeMounts:
    - mountPath: /log
      name: log-volume
  volumes:
  - hostPath:
      path: /var/log/webapp
      type: DirectoryOrCreate
    name: log-volume
```
- Edit the pod to add a sidecar container to send logs to ElasticSearch. Mount the log volume to the sidecar container..
Only add a new container. Do not modify anything else. Use the spec on the right.
   * Name: app
   * Container Name: sidecar
   * Container Image: kodekloud/filebeat-configured
   * Volume Mount: log-volume
   * Mount Path: /var/log/event-simulator/
   * Existing Container Name: app
   * Existing Container Image: kodekloud/event-simulator

```
aster $ cat /var/answers/answer-app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
  namespace: elastic-stack
  labels:
    name: app
spec:
  containers:
  - name: app
    image: kodekloud/event-simulator
    volumeMounts:
    - mountPath: /log
      name: log-volume

  - name: sidecar
    image: kodekloud/filebeat-configured
    volumeMounts:
    - mountPath: /var/log/event-simulator/
      name: log-volume

  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log/webapp
      # this field is optional
      type: DirectoryOrCreate
```



### Pod Life cycle:
  - Pod Status:
     * Pending - Scheduler will allocate the nodes (k describe pod <Pod> - details of why it was pending)
	 * ContainerCreating - Image will be pulled and required resources (mount/ persmission etc)
	 * Running - Start the containers which required resources.
	 * Termination - Once the job is completed, container will die
  - Pod Conditions : (True/False)
     * PodScheduled - when the pods is scheduled in a node it will  place True
	 * Initialized - When all the resources of containters are meat it will set to True
	 * CotainersReady - When all the containers in a pod are ready it will marke as True
	 * Ready - When all the above are meat then pod shows Ready and marked as True
  - When the CotainersReady and Pod Ready are set to True and Cotaners will start the traffice. 
  - Database / Jenkins will take some time to get the application ready, but Pod Status is been set to Ready. Which is False. 
  #### Readiness Probes:
  - Types of Readiness probes can create to an application:
     * HTTP Test : API to check Readyness.
	 * TCP Test : 3306 socket is open for database connections.
     * EXEC Command: To check the application readiness.	 
  - If Readiness is configured, Container will not set the Ready to true, until the Readiness probe is check and available. So that traffice is not passed to the end users.
  
```
apiVersion: v1
kind: Pod
metadata:
  name: web-application
  labels:
    name: web-application
spec:
  containers:
    - name: web-application
	  image: web-application
	  ports:
	    - containerPort: 8080


	  readinessProbe:   ######For HTTP Connection
        httpGet:
          path: /api/ready
          port: 8080
        initialDelaySeconds: 10  #### Additional Delay before Traffice starts
		periodSeconds: 5         #### Check every 5 sec for the 3 probe by default
		failureThreshold: 8      #### To increase the probe from default to 3 to 8
		
		
		
      readinessProbe:   ######For TCP Socket - DBA
	      tcpSocket:
		    port: 3306
		

		
	   readinessProbe:    ######For Exec Commands
	      exec:
		    command:
			  - cat
			  - /app/is_ready.sh
```

## Liveness Probes:
 - if in case of docker container exits and dead, the service ineruption to the customers.
 - In K8s container will be brought up and restart counts to increase.
 - In few cases if container is up but services is not responding then Configure Liveness probe. then Container should restart/recreate to get services to customers.
 ```
 apiVersion: v1
kind: Pod
metadata:
  name: web-application
  labels:
    name: web-application
spec:
  containers:
    - name: web-application
	  image: web-application
	  ports:
	    - containerPort: 8080


	  livenessProbe:   ######For HTTP Connection
        httpGet:
          path: /api/ready
          port: 8080
        initialDelaySeconds: 10  #### Additional Delay before Traffice starts
		periodSeconds: 5         #### Check every 5 sec for the 3 probe by default
		failureThreshold: 8      #### To increase the probe from default to 3 to 8
		
		
		
      livenessProbe:   ######For TCP Socket - DBA
	      tcpSocket:
		    port: 3306
		

		
	   livenessProbe:    ######For Exec Commands
	      exec:
		    command:
			  - cat
			  - /app/is_ready.sh
 ```


### Kubernetes Logs

- K8s will logs and events using below command & -f will shares the live logs
` k logs -f <Pod Name>

- If Pod contains 2 or more containers then they need to sepecify the containers information

`K logs -f <Pod Name> <Container Name>`

### Monitoring

- Metrics Server is current greabs pod utilization etc info, Heapster is deprecated
- Metrics Server stores info in memory.
- Kubelet has Cadvisor component and sending metrics using kubeapi and resonposible for Metrics of K8s.
- metrics components should be installed.
  * `k top node` k top pods` are two commands to check if Metrics is configured and extracting details
  
### Labels Selectors and Annotations:
- Labels to group the objects
- Selectors to match the labels
- Annotations for detilas of authoer, version etc. Can be used for Information puerpose only.
- Sample file:

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: webapp
  labels:
    app: app1
	function: Front-end
  annotations:
    buildversion: 1.34
	author: chaitanya
	email: vurachaitanya@gmail.com
spec:
  replicas: 3
  selector:
    matchLabels:
	  app: app1
  template:
    metadata:
	  labels:
	    app: app1
		function: Front-end
	spec:
	  containers:
	    - name: webapp
		  image: webapp
```

### Rolling updates and Rollbacks in deployments :
- upgrades will done by creating 2 replica sets 1 with old and pulled one at a time and in 2nd replica sets it will create new pods under the deployment.
   * upgrade --> deployment ---> replicaset 1(pull down one at a time)--->replicaset 2 (up one at a time)
- Rolling updates and rollback can be done to make sure if upgrade fails, we can  rolleback to previous version.
- Deployments has got below Strategys:
   * Recreate : disadvantages all pods would bring down, so application will not be avilable for some time. Replica set will be made to 0 and then pull them up with new image
   * Rolling Update: helpful to upgrade in rolling fashion which will not impact the customers. Default strategy for deployments. Pods would be pulled one at a time.
- Deploymentes update can be done to labels, no of replicas, image etc.



- `k run webapp --image=nginx` will create by default deployments. 
- `k rollout status deployment/myapp-deployment` Command to check the status of Rolling  upgrades
- `k rollout history deployment/myapp-deployment` to check history on to the upgrades.
- `k rollout undo deployment/myapp-deployment` to undo the upgrade.
- `k apply -f deployment-definition.yml` for upgrade you can change the image information in file and apply it
- `k set image deployment/myapp-deployment nginx=nginx:1.9.1` to chage the image of deployments on the fly ie command mode.

- Commands:
   * Create: `k create -f deployment-definition.yml`
   * Get: `k get deployments`
   * Update: `k apply -f deployment-definition.yml` & `k set image deployment/myapp-deployment nginx=nginx:1.9.1`
   * Status: `k rollout status deployment/myapp-deployment` & `k rollout history deployment/myapp-deployment`
   * Rollback `k rollout undo deployment/myapp-deployment`

- Change-Cause to understand what is been changed. --record will add the entry to change cause filed so that it would be easy for us to track what has been made changes in the deployments.


- Create deployment: `kubectl create deployment nginx --image=nginx:1.16`
- Check the status `kubectl rollout status deployment nginx`
- Check the status `kubectl rollout history deployment nginx` 
- Roleback `kubectl rollout history deployment nginx --revision=1`
- Mark the command which caused the roleout `kubectl set image deployment nginx nginx=nginx:1.17 --record`
- Check the status ` kubectl rollout history deployment nginx`
- Editing the deployment and changing the image from nginx:1.17 to nginx:latest while making use of the --record flag.`kubectl edit deployments. nginx --record`
- Rollingback `kubectl rollout history deployment nginx --revision=3
deployment.extensions/nginx with revision #3`
- Undo a change `kubectl rollout undo deployment nginx`
- check status `kubectl rollout history deployment nginx`
- rollback to rev 4 `kubectl rollout history deployment nginx --revision=4`


### Jobs

- restartPolicy - always make container up. So that if it is killed on one node it will start on other node because of memory or cpu isues.

```
#### Example:
spec:
  containers:
    - name: math-add
	  image: ubuntu
	  command: [ 'expr', '3', '+', '2']
  restartPolicy: Always #### Always make sure to bring the pod up even if it is killed because of any issues
  
  restartPolicy: Never ####if pod should be exited once the job is completed

``` 
- For batch related job we can use job which is one time task and exits once job completed

```
apiVersion: batch/v1
kind: Jobs
metadata:
  name: math-add-job
spec:
  template:
    spec:
      containers:
        - name: math-add
	      image: ubuntu
	      command: [ 'expr', '3', '+', '2']
	  restartPolicy: Never
```
- `k create -f job-defination.yaml` Create the above job
- `k get jobs` list the jobs
- `k get pods` list the pods of the job
- `k logs match-add-job-x353` to check the job output
- `k delete jo math-add-job` to delete the job.

### Parallelism: 

- to start the pods all at once so that no delay in creation of pods.

```
apiVersion: batch/v1
kind: Jobs
metadata:
  name: math-add-job
spec:
  completions: 3   ###to make sure always we have 3 jobs created but one after the other
  parallelism: 3   ### to create all 3 pods at once with out any delay.
  template:
    spec:
      containers:
        - name: math-add
	      image: ubuntu
	      command: [ 'expr', '3', '+', '2']
	  restartPolicy: Never
```

## Cron job :
- Schedule the jobs for a frequency 
- `k get cronjob` will list the jobs

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
spec:              #### Cronjob Spec for schedule
  schedule: "*/1 * * * *"
  jobTemplate: 
	    spec:           ### Job spec 
          completions: 3 
          parallelism: 3
          template:
		    spec:     ##### Spec for container job
              containers:
              - name: math-add
	            image: ubuntu
	            command: [ 'expr', '3', '+', '2']
	          restartPolicy: Never
```
### backoffLimit
- So that job won't end untill that many attempets were been made. 

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: throw-dice-cron-job
spec:
  schedule: "30 21 * * *"
  jobTemplate:
    spec:
      completions: 3
      parallelism: 3
      backoffLimit: 25 # This is so the job does not quit before it succeeds.
      template:
        spec:
          containers:
          - name: math-add
            image: kodekloud/throw-dice
          restartPolicy: Never
```

### Services:
   - Connection between services of pods.
   - Frontend to end users.
   - external datasources.
   - loosly copuled services
   - Pod ip and Node ip are of different ip. So only services are available internal to the node. To expose it to the user need to use Services.
   - pod ip (10.244.0.2) -->service (30008)-->using Node port ip (192.168.1.2) 
   - Types of Services:
      * Node port
	  * Cluster Port
	  * Loadbalencer Exteral
	- Ports:
	  * TartPort(80) ---> Pod IP: 10.244.0.2
	  * Port(80) ---> Service IP: 10.106.1.12
	  * Node port(30008) ----> Node Service port
	- node pods Range: 30000 - 32767

- Example:

```
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
  
spec:
  type: NodePort
  ports:
    - targetPort: 80  ###Pod port ## IF NOT GIVEN USES PORT INFO
	  port: 80        ###Service port ## MUST REQUIRED
	  nodePort: 30008 ### K8s or Node port ##IF NOT GIVEN USES DEFAULT AVILABLE RANGE PORT
  selector:
      app: myapp
      type: front-end	  
```
- `k get services` gives us the services avilable.
- curl http://192.168.1.2:30008
- For multiple pods should have same labels. Service is created using selector and uses same lable to enable the port across the nodes.
- Uses Random algorithum to select the pods
- SessionAffinity is by default enabled.
- Service is spanned across the nodes based on the pods deployned on nodes.


### ClusterIP
- Full stack app (Fron-end, Back-End, Redis)
- If type is not mentioned, default is ClusterIP.

```
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
  
spec:
  type: ClusterIP
  ports:
    - targetPort: 80
	  port: 80
  selector:
    app: myapp
	type: front-end
```


### Ingress Networking
- Ingress enables customers to use different pages based on pods.
   * google.com ---> google.com/mail & google.com/voice & google.com/youtube
   * SSL Security ask well
   * Based on path route the traffic to respetive services ie mail to mail-deployments of 6 pods.
   * Ingress is LAYER 7 build in K8s feature
   * Even after using Ingress we need to have Node port to expose the URL
- Ingress Components:
   * Ingress Resource
   * Ingress Resource - Rules
   * Ingress Controller  (Uses Nginx, Istio etc)
- Legacy way of using app if Ingress is not present
   * service using cluster ip and port http://129.132.124.124:30054
   * Add DNS to have ip to hostname mapping so as to use http://mystore.com:30054
   * Add Proxy in between to remove the port numbers so as to route the traffice Proxy 30054:80
   * Final version http://mystore.com 
   * If you are using Load Balancer you need to pay for each like http://mystore.com:32342/ware & http://mystore.com:30054/videos if both are comming from different deployments and services. Which is costly.
   * SSL should be enabled to use https://mystore.com.
- To avoide above steps and create multiple sub domains and paths in webpages we can achieve it from Ingress resources - Rules and Ingress controllers. 

- Ingress still requires one node port to expose the application.
- Ingress --> Deploy using (Nginx reverse proxy, HAProxy, traefik, Istio, Contour, GCP HTTP(S)/Load Balancer(GCE))
- Congure ---> SSL Certficate, URL Routes etc 
- Ingress Controller & Ingress Resources 
- CNCF Supported Ingress Controller are Nginx & GCP/GCE

### Ingress Controller:
- Ingress Controller configuration 

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
	  name: nginx-ingress-controller   
  template:
    metadata:
	  labels:
	    name: nginx-ingress
    spec:
	  containers:
	    - name: nginx-ingress-controller
		  image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
	  args:
	    - /nginx-ingress-controller
		-  --configmap=$(POD_NAMESPACE)/nginx-configuration
	  env:
	    - name: POD_NAME
		  valueFrom:
		    fieldRef:
			  fieldPath: metadata.name
	    - name: POD_NAMESPACE
		  valueFrom:
		    fieldRef:
			  fieldPath: metadata.namespace
	  ports:
	    - name: http
		  containerPort: 80
		- name: https
		  containerPort: 443
```
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: NodePort
  ports:
    - port: 80
	  targetPort: 80
	  protocal: TCP
	  name: http
	- port: 443
	  targetPort: 443
	  protocal: TCP
	  name: https
  selector:
    name: nginx-ingress
```
- Service account with required Roles ClusterRoles and RoleBindings should be allocated.
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
  
```
- Configmap to add logs location err redirection etc

```
kind: ConfigMap
apiVersion: v1beta1
metadata:
  name: nginx-configuration
```

### Ingress Resource:

- Creating Ingress Resources for a service.

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear
spec:
  backend:
    serviceName: wear-service
	servicePort: 80
```
- Command to check the ingress status `k get ingress`
  * Shows ingress name Host the traffice should be passed to and address and ports
- Ingress Resources for a service with Path and Rules defined.

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  rules:
   - http:
     paths:
	   - path: /wear
	     backend:
		   serviceName: wear-service
		   servicePort: 80
	   - path: /watch
	     backend:
		   serviceName: watch-service
		   servicePort:80
		   
```
- `k describe ingress ingress-wear-watch` will list the Rules, path, service and port information.

- Domain / Host based Ingress :

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  rules:
   - host: wear.my-online-store.com
      http:
       paths:
	   - backend:
		   serviceName: wear-service
		   servicePort: 80
	- host: watch.my-online-store.com
	  http:
	    paths:
	     - backend:
		     serviceName: watch-service
		     servicePort: 80
		   
```
[Ingress Examples](https://kubernetes.github.io/ingress-nginx/examples/)
[Ingress replace ](https://www.udemy.com/course/certified-kubernetes-application-developer/learn/lecture/16716434#announcements)

- examples ingress Controller, Service account, configmap, Services 

```
master $ cat ingress-controller.yaml
---
#apiVersion: extensions/v1beta1
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ingress-controller
  namespace: ingress-space
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      serviceAccountName: ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
          args:
            - /nginx-ingress-controller
            - --configmap=$(POD_NAMESPACE)/nginx-configuration
            - --default-backend-service=app-space/default-http-backend
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
master $
```
- Ingress Services:

```
 cat ingress-service.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: ingress
  namespace: ingress-space
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    nodePort: 30080
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress
```

- Ingress resources:

```
cat ingress-resource.yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
          serviceName: wear-service
          servicePort: 8080
      - path: /watch
        backend:
          serviceName: video-service
          servicePort: 8080
```
- `kubectl expose deployment -n ingress-space ingress-controller --type=NodePort --port=80 --name=ingress --dry-run -o yaml >ingress.yaml` To expose the Ingress Services.

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /pay
        backend:
          serviceName: pay-service
          servicePort: 8282

```

```
replace("/something(/|$)(.*)", "/$2")

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  name: rewrite
  namespace: default
spec:
  rules:
  - host: rewrite.bar.com
    http:
      paths:
      - backend:
          serviceName: http-svc
          servicePort: 80
        path: /something(/|$)(.*)

```
- sample ingress :

```
master $ cat ingress-pay.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /pay
        backend:
          serviceName: pay-service
          servicePort: 8282
```

[Rewrite ingress example](https://kubernetes.github.io/ingress-nginx/examples/rewrite/)


### Network Policy

- To allow specific traffice to the pod from other pods/ apps
- By default "Allow All" is the Network policy for all the pods, so that no restrection to pod to pod communication and node to pod communication.
- Network policy supported by CNI's are Kube-Router, Calico, Romana, Weave-net.
- Network policy Not suppoted by Flannel.


### Ingress

```
aster $ cat netpol.yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: payroll
    ports:
    - port: 8080
      protocol: TCP
  podSelector:
    matchLabels:
      name: payroll
  policyTypes:
  - Egress
```


```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
spec:
  podSelector:
    matchLabels:
	  role: db
  policyType:
   - Ingress
  ingress:
   - from:
    - podSelector:
	  matchLabels:
	    name: api-pod
	 ports:
	  - protocal: TCP
	    port: 3306

```

- Create a network policy to allow traffic from the 'Internal' application only to the 'payroll-service' and 'db-service'
Policy Name: internal-policy
Policy Types: Egress
Egress Allow: payroll
Payroll Port: 8080
Egress Allow: mysql
MYSQL Port: 3306

### Egress


```
cat answer-internal-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
  - Egress
  - Ingress
  ingress:
    - {}
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: mysql
    ports:
    - protocol: TCP
      port: 3306

  - to:
    - podSelector:
        matchLabels:
          name: payroll
    ports:
    - protocol: TCP
      port: 8080

  - ports:
    - port: 53
      protocol: UDP
    - port: 53
      protocol: TCP
```

- `k get all --all-namespaces` command to view all resources of pods, deplyments, services, replicasets etc.

### Volume & Mounts
- As K8s supports the volume as conainer will not store the data 

```
apiVersion: v1
kind: Pod
metadata:
  name: random-number-generator
spec:
  containers:
    - name: alpine
	  image: alpine
	  command: ["/bin/sh","-c"]
	  args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
	  volumeMounts:
	    - mountPath: /opt
		  name: data-volume
  volumes:
     - name: data-volume
	   hostPath:              #####Host Path Where local host mount path has been used.
	     path: /data
		 type: Directory
  
  
  volumes:                  ####AWS Elastic Store as K8s Volume for a pod
    - name: data-volume
	  awsElasticBlockStore:
	    volumeID: <Volume-id>
		fsType: ext4
		 
```

### Persistance Volume:
- Persistance Volume are cluster wide Pool of storage where pods can be used a peace of volume as a storage.
- PVC - Persistent Volume Claim ()
- PV - Persistent Volume (Pice of storage device from a pool of storages)

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 1Gi
	
  hostPath:
    path: /tmp/data
	
	
  awsElasticBlockStore:
    volumeID: <Volume-id>
	fsType: ext4
```
- `k get persistentvolume` get the status of the volume

### Persistent Volume Claim:

- From storage pool Admin team create PV and Developer will create PVC to use them in the  pods. 
- once PVC is created K8s binds the PV's with PVC's 
- Every PV is bind to single PVC in bind process
- In Bind process it check requested properties Sufficient Capacity, Access Modes, Volume Modes, Storage Class, Selector
- If all the labels are match and PV has more storage and there is no storage option are left then PVC will bind with more capacity storage.  We can't use rest of the volume with other PVC's. 
- If PVC dose not matches with available PV's then it would be in pending state. 


```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
	  storage: 500Mi
```

- `k get pvc` to get the persistent Volume Claims
- `k delete pvc myclaim` will delete PVC
- By default once the PVC is deleted PV remains as is untill it is deleted by K8s admin and PV can't be reused by any PVC.
- `persistentVolumeReclaimPolicy: Retain` is set by default and should be specified with `persistentVolumeReclaimPolicy: Delete` will delete both PVC and PV. 
- `persistentVolumeReclaimPolicy: Recycle` this will delete the data on the volume and ready to reused by other Pods.
- Once you create a PVC use it in a POD definition file by specifying the PVC Claim name under persistentVolumeClaim section in the volumes section.
- The same is true for ReplicaSets or Deployments. Add this to the pod template section of a Deployment on ReplicaSet.

[Volume Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes)

```
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```

### Storage Class:
  - Based on the cost we can prepare platinum: Flash drives, Gold: SSD, Silver: Magnetic drivers.
  - Static Provisioning
  - Dynamic provisioning - Storage Class :  Automatic provision 
  - Using API's GCP will automatically provision the storage ie pv
  
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
  
provisioner: kubernetes.io/gce-pd

```

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: google-storage
  resources:
    requests:
	  storage: 500Mi
```

