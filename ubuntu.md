# making docker work

I was getting frustrating errors from `docker build` that turned out to be DNS-related:

```
Step 7/9 : RUN apk add --no-cache bash
 ---> Running in 16abc7bce60e
fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/main/x86_64/APKINDEX.tar.gz
WARNING: Ignoring http://dl-cdn.alpinelinux.org/alpine/v3.9/main/x86_64/APKINDEX.tar.gz: temporary error (try again later)
```

I added DNS to `/etc/docker/daemon.json`:
```
{
	"dns": ["8.8.8.8", "8.8.8.4"]
}
```
And things are swell.
