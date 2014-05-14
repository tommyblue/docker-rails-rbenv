# Rails on Docker

Build a docker image ready to develop rails apps.
[Rbenv](https://github.com/sstephenson/rbenv) is used to manage ruby.

To change the default ruby version installed (2.1.2), edit the Dockerfile

The image is ready to launch a rails app (tested with 4.1.1).
The supervisor daemon launches a SSH server.

Build the image with: `docker build -t <MY_NAME>/rails-rbenv .`
Launch a container with: `docker run -d -i -t -P <MY_NAME>/rails-rbenv`

User `docker ps` to check which ports are used to map 22 and 3000 ports of the container.
To access the container the user is `railsuser` and the password `s3cr3t` (the user is also a sudoer)

You can ssh into the container and work by terminal or, as I suggest, mount a volume of the host where you have the rails project files, and launch the rails app from the container, so you can use an editor in the host to work on the project:

```
cd /PATH/TO/RAILS/PROJECT
docker run -P -d -i -t -v `pwd`:/home/railsuser/app tommyblue/rails-rbenv
```

SSH into the container then install required gems:

```
ssh railsuser@127.0.0.1 -p <CONTAINER_SSH_PORT>
cd ~/app
bundle install
bundle exec rails server
```
