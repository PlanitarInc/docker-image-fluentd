
The container runs `fluentd` configured read docker logs from
`/tmp/lib/docker/containers` directory.
Configure `fluentd` config to accept docker logs streamed by logspout
on `5141/udp` port.

Each docker log line is expected to be a JSON object structured as follows:
 - `name`: container name
 - `id`: container id
 - `type`: stream type (`stdout` or `stderr`)
 - `data`: a single logged line

Fluentd stores hourly every stream of every container to a separate file on S3:
 - `logs/docker/%YYYY-%MM-%DD/${hostname}/${name}-${id}_${type}.%HH:00.gz`
every line is a JSON object structured as follows:
 - `timestamp`: a timestamp with millisecond resolution (`%Y-%m-%dT%H:%M:%S.%L%z')
 - `message`: a single logged line (original `data` field)
 - any other fields in original JSON excluding `id`, `name` and `type`.

### Run

Optional ENV VARS:
 - `AWS_S3_REGION`, default `us-east-1`
 - `AWS_S3_BUCKET`, default `system.plntr.ca`
 - `DOCKER_UDP_PORT`, default `5141`

#### EC2 instance with IAM profile

Read the docker logs from /var/lib/docker/containers:

```sh
docker run -d --name fluentd \
  -v /var/lib/docker:/tmp/lib/docker -h $(hostname) \
  planitar/fluentd
```

Read the docker logs from 5141/udp streamed by logspout:

```sh
docker run -d --name fluentd -p 5141:5141/udp -h $(hostname) \
  planitar/fluentd
```

#### Specific keys

```sh
docker run -d --name fluentd -h $(hostname) -p 5141:5141/udp \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  planitar/fluentd
```

#### Specific temporal keys

```sh
docker run -d --name fluentd -h $(hostname) -p 5141:5141/udp \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  planitar/fluentd
```
