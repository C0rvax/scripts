#!/bin/bash

cd /home/c0rvax/Code/TC/

commit_and_push() {
	git add .
	git commit -m "Commit for $(date +"%Y-%m-%d %T")"
	git push
}

# if ! git diff-index --quiet HEAD --; then
# git add .
# git commit -m "Commit for $(date +"%Y-%m-%d %T")"
# git push
# fi
if [ -z "$(git status --porcelain)" ]; then
	exit 0
else
	commit_and_push
fi
