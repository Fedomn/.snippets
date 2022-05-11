上传文件
kubectl cp /tmp/foo <some-namespace>/<some-pod>:/tmp/bar

全量安装
https://arthas.aliyun.com/doc/install-detail.html#id2

cp tools.jar /opt/java/openjdk/lib/tools.jar


profiler: https://arthas.aliyun.com/doc/profiler.html
profiler start --event alloc
profiler start --event cpu
profiler start --event itimer
profiler stop --format html


常用方法
monitor -c 3 org.class.path methodName
trace org.class.path methodName
watch org.class.path methodName "{params[8]}" -x 1


java -Xmx4816M -XX:+UseG1GC -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:./gc.log -jar app.jar

