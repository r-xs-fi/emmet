# NOTE use a separate builder to avoid having to ship full NPM in the runtime image.
# 
# NOTE we can use build platform -native builder for the build step because we're copying
#      to runtime image only JavaScript files which are CPU arch agnostic.
FROM --platform=linux/amd64 alpine:latest AS builder

RUN apk add nodejs npm

RUN npm add -g emmet-cli

FROM alpine:latest

# there is also `/usr/local/bin/emmet` but that is symlink to this.
# first I copied the "binary" directly (making it regular file not symlink)
# but seems NodeJS needs the symlink info in order to know where from to resolve imports.
ENTRYPOINT ["/usr/local/lib/node_modules/emmet-cli/index.js"]

RUN apk add --no-cache nodejs

COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# run as unprivileged user
USER 1000:1000

