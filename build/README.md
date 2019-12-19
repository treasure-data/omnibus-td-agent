These directories contain Dockerfiles for the Stackdriver Logging agent build
containers on various OS distros. These build containers are based on the
respective Linux distro base images, because the Logging agent Linux package
builds use [Omnibus](http://github.com/chef/omnibus), which, by default,
configures the build based on detecting the distribution it's invoked in.
The containers provide hermetic environments for the various distros supported
by the agent, with preinstalled and preconfigured dependencies to speed up the
builds and make them reproducible.
