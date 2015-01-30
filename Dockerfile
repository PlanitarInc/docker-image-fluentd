FROM planitar/dev-ruby

RUN gem install --no-ri --no-rdoc fluentd:0.12.4 \
    fluent-plugin-s3 fluent-plugin-record-reformer fluent-plugin-forest

ADD fluentd.conf /etc/fluent/

ENV AWS_S3_REGION us-east-1
ENV AWS_S3_BUCKET system.plntr.ca

EXPOSE 5141

ENTRYPOINT ["/usr/bin/fluentd", "--use-v1-config", "-c", "/etc/fluent/fluentd.conf"]
