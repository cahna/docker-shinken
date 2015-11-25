
# docker-shinken

```yaml
---
shinken_data:
  container_name: shinken_data
  image: cheine/shinken
  entrypoint: /bin/true
  volumes:
    - ./etc:/etc/shinken:ro
    - /var/lib/shinken:/var/lib/shinken
    - ./logs:/var/log/shinken
    - ./pids:/var/run/shinken

shinken_scheduler:
  container_name: shinken_scheduler
  image: cheine/shinken
  restart: always
  command: shinken-scheduler -c /etc/shinken/daemons/schedulerd.ini
  volumes_from:
    - shinken_data
  ports:
    - 127.0.0.1:7768:7768

shinken_poller:
  container_name: shinken_poller
  image: cheine/shinken
  restart: always
  command: shinken-poller -c /etc/shinken/daemons/pollerd.ini
  volumes_from:
    - shinken_data
  ports:
    - 127.0.0.1:7771:7771

shinken_reactionner:
  container_name: shinken_reactionner
  image: cheine/shinken
  restart: always
  command: shinken-reactionner -c /etc/shinken/daemons/reactionnerd.ini
  volumes_from:
    - shinken_data
  ports:
    - 127.0.0.1:7769:7769

shinken_broker:
  container_name: shinken_broker
  image: cheine/shinken
  restart: always
  command: shinken-broker -c /etc/shinken/daemons/brokerd.ini
  volumes_from:
    - shinken_data
  ports:
    - 127.0.0.1:7772:7772

shinken_receiver:
  container_name: shinken_receiver
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
  container_name: shinken_arbiter
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

