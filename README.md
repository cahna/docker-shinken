
# docker-shinken

Each of the Shinken daemons may be started using this Docker image.

```yaml
# docker-compose.yml
---
# Use a data container to easily share shinken configuration between containers
shinken_data:
  image: cheine/shinken
  entrypoint: /bin/true
  volumes:
    - ./etc:/etc/shinken:ro
    - /var/lib/shinken:/var/lib/shinken
    - ./logs:/var/log/shinken
    - ./pids:/var/run/shinken

shinken_scheduler:
  image: cheine/shinken
  restart: always
  command: shinken-scheduler -c /etc/shinken/daemons/schedulerd.ini
  volumes_from:
    - shinken_data

shinken_poller:
  image: cheine/shinken
  restart: always
  command: shinken-poller -c /etc/shinken/daemons/pollerd.ini
  volumes_from:
    - shinken_data

shinken_reactionner:
  image: cheine/shinken
  restart: always
  command: shinken-reactionner -c /etc/shinken/daemons/reactionnerd.ini
  volumes_from:
    - shinken_data

shinken_broker:
  image: cheine/shinken
  restart: always
  command: shinken-broker -c /etc/shinken/daemons/brokerd.ini
  volumes_from:
    - shinken_data

shinken_receiver:
  image: cheine/shinken
  restart: always
  command: shinken-receiver -c /etc/shinken/daemons/receiverd.ini
  volumes_from:
    - shinken_data
  links:
    - shinken_scheduler:shinken_scheduler
    - shinken_poller:shinken_poller
    - shinken_reactionner:shinken_reactionner
    - shinken_broker:shinken_broker
  ports:
    - 127.0.0.1:7773:7773

shinken_arbiter:
  image: cheine/shinken
  hostname: shinken_arbiter
  restart: always
  command: shinken-arbiter -c /etc/shinken/shinken.cfg
  volumes_from:
    - shinken_data
  links:
    - shinken_scheduler:shinken_scheduler
    - shinken_poller:shinken_poller
    - shinken_reactionner:shinken_reactionner
    - shinken_broker:shinken_broker
    - shinken_receiver:shinken_receiver
  ports:
    - 0.0.0.0:7799:7799
    - 0.0.0.0:7780:7780
```

