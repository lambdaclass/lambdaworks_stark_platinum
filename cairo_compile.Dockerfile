FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && \
  apt-get install -y --no-install-recommends g++ libgmp3-dev && \
  pip install ecdsa==0.18.0 \
  bitarray==2.7.3 \
  fastecdsa==2.2.3 \
  sympy==1.11.1 \
  typeguard==2.13.3 \
  cairo-lang==0.11.0

CMD ["cairo-compile"]
