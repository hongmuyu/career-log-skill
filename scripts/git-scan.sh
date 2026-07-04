#!/usr/bin/env bash
# git-scan.sh - 扫描 git 仓库最近变更，输出结构化信息供 skill 使用
# 用法: bash git-scan.sh [repo_path]

set -euo pipefail

REPO_PATH="${1:-.}"
cd "$REPO_PATH"

# 检查是否在 git 仓库中
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "NOT_A_GIT_REPO"
  exit 0
fi

# 仓库名（从目录名推断）
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
echo "REPO_NAME=$REPO_NAME"

# 当前分支
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
echo "BRANCH=$BRANCH"

# 最近 5 条 commit（简洁格式）
echo "---COMMITS---"
git log --oneline -5 2>/dev/null || echo "NO_COMMITS"

# 最近一次 commit 的 diff 统计
echo "---DIFF_STAT---"
if git diff HEAD~1 --stat 2>/dev/null | head -20; then
  :
else
  echo "NO_DIFF"
fi

# 最近一次 commit 涉及的文件类型（推断技术栈）
echo "---FILE_TYPES---"
git diff HEAD~1 --name-only 2>/dev/null | sed 's/.*\.//' | sort -u | head -20 || echo "NO_FILES"

# 未提交的变更
echo "---UNSTAGED---"
if git diff --stat 2>/dev/null | head -10; then
  :
else
  echo "NO_UNSTAGED"
fi

echo "---STAGED---"
if git diff --cached --stat 2>/dev/null | head -10; then
  :
else
  echo "NO_STAGED"
fi
