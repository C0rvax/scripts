#!/bin/bash

# Date in format Day-Month-Year
date=$(date +"%Y-%m-%d %T")

# Commit message
message="Commit for $date"
cd /home/c0rvax/Code/TC/

commit_and_push() {
	git add .
	git commit -m "$message"
	git push
}

if [ -z "$(git status --porcelain)" ]; then
	exit 0
else
	commit_and_push
fi
