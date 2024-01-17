# This Dockerfile is only for GitHub Actions
FROM docker.artifactory.sherwin.com/sherwin-williams-co/iodp/fylki2.0/python/python:3.11

RUN apt-get update && \
    apt-get install --yes default-jre-headless && \
    apt-get install --yes ca-certificates && \
    apt-get upgrade --yes

ADD http://swroot.sherwin.com/swroot.pem /usr/local/share/ca-certificates/swroot.crt
RUN update-ca-certificates

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    git-lfs

# install backported stable version of git, which supports ssh signing
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list; \
    apt-get update;\
    apt-get install -y git/bullseye-backports

ENV PYTHONPATH /semantic-release

COPY . /semantic-release

RUN cd /semantic-release && \
    python -m venv /semantic-release/.venv && \
    /semantic-release/.venv/bin/pip install .

RUN /semantic-release/.venv/bin/python -m semantic_release --help

ENTRYPOINT ["/semantic-release/action.sh"]
