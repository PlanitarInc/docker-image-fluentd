FROM planitar/dev-ruby

RUN gem install --no-ri --no-rdoc fluentd:0.12.4 \
    fluent-plugin-record-reformer fluent-plugin-forest && \
    mkdir /src && cd /src && \
      git clone https://github.com/PlanitarInc/fluent-plugin-s3 && \
      cd fluent-plugin-s3 && \
      gem build fluent-plugin-s3.gemspec && \
      gem install --no-ri --no-rdoc fluent-plugin-s3-plntr && \
    rm -r /src && \
    mkdir /src && cd /src && \
      git clone https://github.com/PlanitarInc/fluent-plugin-docker-format \
        --branch plntr-gemname && \
      cd fluent-plugin-docker-format && \
      gem build fluent-plugin-docker-format.gemspec && \
      gem install --no-ri --no-rdoc fluent-plugin-docker-format-plntr && \
    rm -r /src

ADD fluentd.conf /etc/fluent/

ENV AWS_S3_REGION us-east-1
ENV AWS_S3_BUCKET system.plntr.ca

EXPOSE 5141

ENTRYPOINT ["/usr/bin/fluentd", "--use-v1-config", "-c", "/etc/fluent/fluentd.conf"]
