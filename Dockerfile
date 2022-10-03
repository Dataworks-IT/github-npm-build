FROM node:14

LABEL "com.github.actions.name"="Build App with npm"
LABEL "com.github.actions.description"="This action will build your App using npm run build."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="http://github.com/erikrob/github-npm-build"
LABEL "homepage"="http://github.com/erikrob/github-npm-build"
LABEL "maintainer"="Ezequiel Leites <ezequiel@leites.dev>"

ADD $HOME/.aws/credentials /github/home/.aws/credentials
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
