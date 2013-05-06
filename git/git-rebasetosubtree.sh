#! /bin/bash
# check for provided directory
if [ -z "$1" ]
then
    echo "Need the directory to get content rebased !"
    exit 1
fi
DIR=$1
BRANCH=$(git rev-parse --abbrev-ref HEAD)
NEWBRANCH="new-$BRANCH-rebased"

# check provided directory exists
if [ -z `git ls-tree master | grep -o $DIR` ]
then
    echo "$DIR does not seem to exist on branch : $BRANCH !"
    exit 1
fi

# create target tree using provided directory subtree
HASH=$(git ls-tree $BRANCH $1/ | sed -e "s/$1\///" | git mktree)
HASH=$(echo "remove $1 from repository tree" | git commit-tree $HASH)
echo $HASH
# check for existing target branch
git show-ref --verify --quiet "refs/heads/$NEWBRANCH"
if [[ $? != 0 ]]
then
echo 'not exists'
    # checkout the target tree in a new branch
    git checkout -b $NEWBRANCH $HASH
else
echo 'exists'
    # rebase the branch
    git checkout $NEWBRANCH && git rebase -p $HASH
fi

# merge the original log
git merge -s ours -m "Merge $BRANCH into current with ours strategy to keep logs" $BRANCH
# rebase the log
git rebase -f HEAD^
