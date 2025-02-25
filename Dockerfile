FROM python:3.9

# Add these near the top of your Dockerfile
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

# Set them as environment variables
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

RUN apt-get -qq update && apt-get -qqy install awscli

# Install dependencies
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Add the cc-index-server code into the image
COPY ./ /opt/webapp/
WORKDIR /opt/webapp

RUN chmod +x ./install-collections.sh
RUN ./install-collections.sh
# Note: to avoid that collections are fetched anew on every image build,
# you may install collections locally on the host in the build directory
# and remove this command

COPY config.yaml /opt/webapp/config.yaml

CMD /usr/local/bin/wayback
