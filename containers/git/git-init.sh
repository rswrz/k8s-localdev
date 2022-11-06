#!/bin/sh

for repo in ${@:?}; do
    dir="/var/www/htdocs/git/${repo}.git"
    git -C "$(dirname "$dir")" init --bare --shared --initial-branch=main "${repo}.git"
    git -C "$dir" config --bool http.receivepack true
    git -C "$dir" config --bool receive.denyNonFastforwards false
    chown -R nginx:www-data "$dir"
done
