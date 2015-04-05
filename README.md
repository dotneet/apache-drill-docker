Apache Drillを起動するためのDockerfileです。

##使い方

起動

```
docker build -t drill .
run.sh <起動するコンテナ数> drill
```

drill_<n> という名前で各コンテナを起動します。  
こんな感じでログインしてください。

```
sudo docker exec -ti drill_1 /bin/bash
```

##現状
ZooKeeperで各コンテナを接続するところまでは自動でやってくれます。

