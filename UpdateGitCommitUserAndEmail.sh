$ cat changeCommit.sh
#!/bin/sh
# 批量修改git已提交用户名和邮箱
git filter-branch --env-filter '

# 之前的邮箱
OLD_EMAIL="yjzcode@qq.com"
# 修改后的用户名
CORRECT_NAME="xiaoyu"
# 修改后的邮箱
CORRECT_EMAIL="jiangzhong91@gmail.com"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags