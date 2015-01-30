
The container runs `fluentd` configured to accept docker logs on `5141/udp`
port.
Each docker log line is expected to be a JSON object structured as follows:
 - `name`: container name
 - `id`: container id
 - `type`: stream type (`stdout` or `stderr`)
 - `data`: a single logged line

Fluentd stores hourly every stream of every container to a separate file on S3:
 - `logs/docker/%YYYY-%MM-%DD/${hostname}/${name}-${id}_${type}.%HH.gz`
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

```sh
docker run -ti -h $(hostname) -p 5141:5141/udp \
  planitar/fluentd
```

#### Specific keys

```sh
docker run -ti -h $(hostname) -p 5141:5141/udp \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  planitar/fluentd
```

#### Specific temporal keys

```sh
docker run -ti -h $(hostname) -p 5141:5141/udp \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  planitar/fluentd
```
