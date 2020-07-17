## WebApp Code: 
- https://kodekloud.com/courses/kubernetes-certification-course-labs/lectures/12039441

```
pod/simple-webapp-deployment-677668f6b-88ssl
========================
cat Dockerfile
FROM python:3.6-alpine

ADD requirements.txt /

RUN pip install -r requirements.txt

ADD . /

ENTRYPOINT ["python", "app.py"]

ENV APP_COLOR red

===============================
 cat requirements.txt
Flask/ #

=============================
 # cat app.py
import os
from flask import Flask
from flask import render_template
import socket
import random
import os

app = Flask(__name__)

color_codes = {
    "red": "#e74c3c",
    "green": "#16a085",
    "blue": "#2980b9",
    "blue2": "#30336b",
    "pink": "#be2edd",
    "darkblue": "#130f40"
}

color = os.environ.get('APP_COLOR') or random.choice(["red","green","blue","blue2","darkblue","pink"])

@app.route("/")
def main():
    #return 'Hello'
    print(color)
    return render_template('hello.html', name=socket.gethostname(), color=color_codes[color])

@app.route('/color/<new_color>')
def new_color(new_color):
    return render_template('hello.html', name=socket.gethostname(), color=color_codes[new_color])

@app.route('/read_file')
def read_file():
    f = open("/data/testfile.txt")
    contents = f.read()
    return render_template('hello.html', name=socket.gethostname(), contents=contents, color=color_codes[color])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port="8080")
	
-------------------
master $ k get deployments simple-webapp-deployment -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  creationTimestamp: "2020-07-17T07:26:04Z"
  generation: 1
  managedFields:
  - apiVersion: apps/v1
    fieldsType: FieldsV1
    fieldsV1:
      f:spec:
        f:progressDeadlineSeconds: {}
        f:replicas: {}
        f:revisionHistoryLimit: {}
        f:selector:
          f:matchLabels:
            .: {}
            f:name: {}
        f:strategy:
          f:rollingUpdate:
            .: {}
            f:maxSurge: {}
            f:maxUnavailable: {}
          f:type: {}
        f:template:
          f:metadata:
            f:labels:
              .: {}
              f:name: {}
          f:spec:
            f:containers:
              k:{"name":"simple-webapp"}:
                .: {}
                f:image: {}
                f:imagePullPolicy: {}
                f:name: {}
                f:ports:
                  .: {}
                  k:{"containerPort":8080,"protocol":"TCP"}:
                    .: {}
                    f:containerPort: {}
                    f:protocol: {}
                f:resources: {}
                f:terminationMessagePath: {}
                f:terminationMessagePolicy: {}
            f:dnsPolicy: {}
            f:restartPolicy: {}
            f:schedulerName: {}
            f:securityContext: {}
            f:terminationGracePeriodSeconds: {}
    manager: python-requests
    operation: Update
    time: "2020-07-17T07:26:04Z"
  - apiVersion: apps/v1
    fieldsType: FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .: {}
          f:deployment.kubernetes.io/revision: {}
      f:status:
        f:availableReplicas: {}
        f:conditions:
          .: {}
          k:{"type":"Available"}:
            .: {}
            f:lastTransitionTime: {}
            f:lastUpdateTime: {}
            f:message: {}
            f:reason: {}
            f:status: {}
            f:type: {}
          k:{"type":"Progressing"}:
            .: {}
            f:lastTransitionTime: {}
            f:lastUpdateTime: {}
            f:message: {}
            f:reason: {}
            f:status: {}
            f:type: {}
        f:observedGeneration: {}
        f:readyReplicas: {}
        f:replicas: {}
        f:updatedReplicas: {}
    manager: kube-controller-manager
    operation: Update
    time: "2020-07-17T07:27:28Z"
  name: simple-webapp-deployment
  namespace: default
  resourceVersion: "5830"
  selfLink: /apis/apps/v1/namespaces/default/deployments/simple-webapp-deployment
  uid: 442c27eb-80b8-47b1-8722-bbdfb3206034
spec:
  progressDeadlineSeconds: 600
  replicas: 4
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      name: simple-webapp
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        name: simple-webapp
    spec:
      containers:
      - image: kodekloud/simple-webapp:red
        imagePullPolicy: IfNotPresent
        name: simple-webapp
        ports:
        - containerPort: 8080
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 4
  conditions:
  - lastTransitionTime: "2020-07-17T07:27:25Z"
    lastUpdateTime: "2020-07-17T07:27:25Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2020-07-17T07:26:04Z"
    lastUpdateTime: "2020-07-17T07:27:28Z"
    message: ReplicaSet "simple-webapp-deployment-677668f6b" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 1
  readyReplicas: 4
  replicas: 4
  updatedReplicas: 4
master $
=========================
master $ Connection to host01 closed by remote host.
Connection to host01 closed.

The environment has expired.

Please refresh to get a new environment

```
