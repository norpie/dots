# The FROM instruction sets the Base Image for subsequent instructions.
# As such, a valid Dockerfile must have FROM as its first instruction.
#
# The tag or digest values are optional. If you omit either of them,
# the builder assumes a latest by default.
#
# The scratch image is an empty base container.
#
# FROM <image>[:<tag>|@<digest]
FROM scratch

# The MAINTAINER instruction allows you to set the Author field of the
# generated images.
#
# MAINTAINER <name>
MAINTAINER Konsta Kuosmanen <konsta@kuosmanen.dev>

# The VOLUME instruction creates a mount point with the specified name and
# marks it as holding externally mounted volumes from native host or other
# containers. The value can be a JSON array, VOLUME ["/var/log/"], or a plain
# string with multiple arguments, such as VOLUME /var/log or VOLUME /var/log
# /var/db.
#
# * The list is parsed as a JSON array, which means that you must use double
#   quotes (") around words not single-quotes (').
#
# VOLUME <mount_point> ...
# VOLUME [ "<mount_point>", ... ]
VOLUME /srv/data

# The ARG instruction defines a variable that users can pass at build-time to
# the builder with the docker build command using the --build-arg <varname>=<value>
# flag. If a user specifies a build argument that was not defined in the Dockerfile,
# the build outputs an error.
#
# Warning: It is not recommended to use build-time variables for passing secrets like
#          github keys, user credentials etc. Build-time variable values are visible to
#          any user of the image with the docker history command.
#
# Environment variables defined using the ENV instruction always override an ARG
# instruction of the same name.
#
# Docker has a set of predefined ARG variables that you can use without a corresponding
# ARG instruction in the Dockerfile:
#
# * HTTP_PROXY
# * http_proxy
# * HTTPS_PROXY
# * https_proxy
# * FTP_PROXY
# * ftp_proxy
# * NO_PROXY
# * no_proxy
#
# To use these, simply pass them on the command line using the --build-arg <varname>=<value> flag.
#
# ARG variables are not persisted into the built image as ENV variables are. However, ARG variables do
# impact the build cache in similar ways.
#
# ARG <name>[=<default value>]
ARG myvar=testval

# The ENV instruction sets the environment variable <key> to the value
# <value>. This value will be in the environment of all "descendent"
# Dockerfile commands and can be replaced inline in many as well.
#
# The environment variables set using ENV will persist when a container
# is run from the resulting image. You can view the values using docker
# inspect, and change them using docker run --env <key>=<value>.
#
# Environment variables can be used in the following instructions:
# * ADD
# * COPY
# * ENV
# * EXPOSE
# * LABEL
# * USER
# * WORKDIR
# * VOLUME
# * STOPSIGNAL
# * ONBUILD (when combined with one of the supported instructions above)
#
# ENV <key> <value>
# ENV <key>=<value> ...
ENV ENV_VAR "value"

# The EXPOSE instructions informs Docker that the container will listen on
# the specified network ports at runtime. Docker uses this information to
# interconnect containers using links (see the Docker User Guide) and to
# determine which ports to expose to the host when using the -P flag.
#
# EXPOSE <port> [<port>...]
EXPOSE 80

# The COPY instruction copies new files or directories from <src> and adds
# them to the filesystem of the container at the path <dest>.
#
# Multiple <src> resource may be specified but they must be relative to the
# source directory that is being built (the context of the build).
#
# Each <src> may contain wildcards and matching will be done using Go's
# filepath.Match rules.
#
# The <dest> is an absolute path, or a path relative to WORKDIR, into which
# the source will be copied inside the destination container.
#
# All new files and directories are created with a UID and GID of 0.
#
# The copy obeys the following rules:
#
# * The <src> path must be inside the context of the build; you cannot
#   COPY ../something /something, because the first step of a docker build
#   is to send the context directory (and subdirectories) to the docker
#   daemon.
#
# * If <src> is a directory, the entire contents of the directory are copied,
#   including filesystem metadata.
#   - Note: The directory itself is not copied, just its contents.
#
# * If <src> is any other kind of file, it is copied individually along with
#   its metadata. In this case, if <dest> ends with a trailing slash /, it
#   will be considered a directory and the contents of <src> will be written
#   at <dest>/base(<src>).
#
# * If multiple <src> resources are specified, either directly or due to the
#   use of a wildcard, then <dest> must be a directory, and it must end with
#   a slash /.
#
# * If <dest> does not end with a trailing slash, it will be considered a
#   regular file and the contents of <src> will be written at <dest>.
#
# * If <dest> doesn't exist, it is created along with all missing directories
#   in its path.
#
# COPY <src>... <dest>
# COPY ["<src>"... "<dest>"] (this form is required for paths containing
#                             whitespace)
COPY src/file.cpp /usr/include/mylib/file.cpp

# The WORKDIR instruction sets the working directory for any RUN, CMD,
# ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile.
#
# It can be used multiple times in the one Dockerfile. If a relative path
# is provided, it will be relative to the path of the previous WORKDIR
# instruction.
#
# WORKDIR <path>
WORKDIR /path/to/workdir

# The RUN instruction will execute any commands in a new layer on top of
# the current image and commit the results. The resulting committed image
# will be used for the next step in the Dockerfile.
#
# The exec form makes it possible to avoid shell string munging, and to
# RUN commands using a base image that does not contain /bin/sh.
#
# * To use a different shell, other than '/bin/sh', use the exec form
#   passing in the desired shell. For example, RUN ["/bin/bash", "-c",
#   "echo hello"]
# * The exec form is parsed as a JSON array, which means that you must
#   use double-quotes (") around words not single-quotes (').
# * The exec form does not invoke a command shell. This means that normal
#   shell processing like variable substitution does not happen.
#
# Note: To use a different shell, other than ‘/bin/sh’, use the exec form
#       passing in the desired shell. For example, RUN ["/bin/bash", "-c", "echo hello"]
# Note: The exec form is parsed as a JSON array, which means that you must
#       use double-quotes (“) around words not single-quotes (‘).
# Note: Unlike the shell form, the exec form does not invoke a command shell.
#       This means that normal shell processing does not happen. For example,
#       RUN [ "echo", "$HOME" ] will not do variable substitution on $HOME.
#       If you want shell processing then either use the shell form or execute a
#       shell directly, for example: RUN [ "sh", "-c", "echo $HOME" ].
# Note: In the JSON form, it is necessary to escape backslashes. This is particularly
#       relevant on Windows where the backslash is the path separator. The following line
#       would otherwise be treated as shell form due to not being valid JSON, and fail in an
#       unexpected way: RUN ["c:\windows\system32\tasklist.exe"] The correct syntax for this
#       example is: RUN ["c:\\windows\\system32\\tasklist.exe"]
#
# RUN <command> (the command is run in a shell - /bin/sh -c - shell form)
# RUN ["executable", "param1", "param2"] (exec form)
RUN /usr/sbin/nologin

# An ENTRYPOINT allows you to configure a container that will run as an
# executable.
#
# * You can over ride the ENTRYPOINT setting using --entrypoint, but this
#   can only set the binary to exec (no sh -c will be used).
# * The exec form is parsed as a JSON array, which means that you must
#   use double-quotes (") around words not single-quotes (').
# * The exec form does not invoke a command shell. This means that normal
#   shell processing like variable substitution does not happen.
#
# ENTRYPOINT ["executable", "param1", "param2"] (the preferred exec form)
# ENTRYPOINT command param1 param2 (shell form)
ENTRYPOINT top -b

# There can only be one CMD instruction in a Dockerfile. If you list more
# than one CMD then only the last CMD will take effect.
#
# The main purpose of a CMD is to provide defaults for an executing container.
# These defaults can include an executable, or they can omit the executable,
# in which case you must specify an ENTRYPOINT instruction as well.
#
# Note: If CMD is used to provide default arguments for the ENTRYPOINT instruction,
#       both the CMD and ENTRYPOINT instructions should be specified with the
#       JSON array format.
# Note: The exec form is parsed as a JSON array, which means that you must
#       use double-quotes (“) around words not single-quotes (‘).
# Note: Unlike the shell form, the exec form does not invoke a command shell.
#       This means that normal shell processing does not happen. For example,
#       CMD [ "echo", "$HOME" ] will not do variable substitution on $HOME.
#       If you want shell processing then either use the shell form or execute a
#       shell directly, for example: CMD [ "sh", "-c", "echo $HOME" ].
#
# If you would like your container to run the same executable every time,
# then you should consider using ENTRYPOINT in combination with CMD.
#
# CMD ["executable","param1","param2"] (exec form, this is the preferred form)
# CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
# CMD command param1 param2 (shell form)
CMD /usr/bin/default_cmd
