#! /bin/bash
# this script will help you to rebase a repository to a subtree of it
# check for provided directory
if [ -z "$1" ]
then
    echo "Need the directory to get content rebased !"
    exit 1
fi
DIR=`echo $1 | sed 's/\/$//'`
BRANCH=$(git rev-parse --abbrev-ref HEAD)
NEWBRANCH="new-$BRANCH-rebased"

# check provided directory exists
if [ -z `git ls-tree $BRANCH | grep -o $DIR` ]
then
    echo "$DIR does not seem to exist on branch : $BRANCH !"
    exit 1
fi

# check for existing target branch
git show-ref --verify --quiet "refs/heads/$NEWBRANCH"
if [[ $? != 0 ]]
then
    # checkout the target tree in a new branch
    git checkout -b $NEWBRANCH $HASH
else
    # rebase the branch
    git checkout $NEWBRANCH && git rebase -p $BRANCH
fi

# check we are on the right branch
if [[ `git rev-parse --abbrev-ref HEAD` == "$NEWBRANCH" ]]
then
    # --all
    git filter-branch -f --prune-empty --subdirectory-filter $DIR HEAD -- && git gc --aggressive --prune=now
fi
