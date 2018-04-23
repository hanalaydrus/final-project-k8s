apiVersion: v1
kind: Service
metadata:
  name: authservice
  labels:
    app: triplogic
    servicename: authservice
spec:
  ports:
    - port: 9221
      name: grpc
  selector:
    app: authservice
    tier: backend
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: authservice
  labels:
    app: authservice
    tier: backend
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: authservice
        tier: backend
        phase: beta
        version: v1.4
    spec:
      containers:
      - name: authservice
        image: gcr.io/triplogic-190611/bitbucket-triplogic-authservice:v1.4-beta
        env:
        - name : DB_CONNECTION
          value : "tcp(mysql:3306)"
        - name : DB_NAME
          value : "triplogic"
        - name : TRIPLOGIC_API_URL
          value : "https://triplogic.io/v1"
        - name: DB_ROOT_PASS
          valueFrom:
            secretKeyRef:
              name: mysql-config
              key: mysql-root-pass.txt
        ports:
        - name: grpc-auth
          containerPort: 9221
        
      restartPolicy: Always