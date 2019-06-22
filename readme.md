# lynncyrin/base-image

A personalized and well documented [docker](https://www.docker.com/) dev time base image.

## Status

High level components added:

- [ ] python
- [ ] golang
- [ ] nodejs
- [ ] rust
- [ ] ruby

## Motivation and Context

I do my dev work on both osx and windows, so its nice to have a linux container to work in.

Also at this point in my career, I'm consistently writing in a variety of different languages. To ease the effort it takes to context switch (and also mirror local dev) its nice to have a docker container that contains all my languages.

I'm also an infrastructure engineer, so exactly how each language is built is very interesting to me! So I'm building each language from source, rather than copying for pre-built sources. This also makes it slightly easier for me to do dev work on the language itself (I'm currently planning on doing this for `python`)

It you're thinking of doing something similar for personal use, but don't want to deal with so much docker / ubuntu / bash, then `docker run -it python bash` (or whatever language) works perfectly fine!
