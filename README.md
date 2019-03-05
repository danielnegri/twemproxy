# Twemproxy (Docker)

This is a Docker image for [twemproxy](https://github.com/twitter/twemproxy) (pronounced "two-em-proxy"), aka nutcracker, a fast and lightweight proxy for memcached and redis protocol. It was built primarily to reduce the number of connections to the caching servers on the backend. This, together with protocol pipelining and sharding enables you to horizontally scale your distributed caching architecture.


## Usage

Create a `nutcracker.yml` file like the following:

```yml
alpha:
  listen: 127.0.0.1:22121
  hash: fnv1a_64
  distribution: ketama
  auto_eject_hosts: true
  redis: true
  server_retry_timeout: 2000
  server_failure_limit: 1
  servers:
   - redis:6379:1
```

```
$ docker run -it --rm -p 22121:22121 -v $PWD/nutcracker.yml:/etc/nutcracker.yml danielnegri/twemproxy
```
