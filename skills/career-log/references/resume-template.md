# 简历条目模板规则

## 输出格式

同一项目的多条记录挂在同一个项目标题下，按时间倒序排列。

### 单条记录示例

```markdown
## A2A-Gateway

> 基于 Go 的 Agent-to-Agent 通信网关中间件 | 后端开发

- **修复 WebSocket goroutine 泄漏**：高并发下连接池泄漏导致服务 OOM，
  使用 pprof 定位后引入 derived context 自动释放 goroutine，
  泄漏率降为 0，72h 压测稳定
```

### 多条记录示例

```markdown
## A2A-Gateway

> 基于 Go 的 Agent-to-Agent 通信网关中间件 | 后端开发

- **优化消息路由性能**：路由表全量扫描导致 P99 延迟 800ms，
  改用前缀树索引后降至 15ms，吞吐提升 50 倍
- **修复 WebSocket goroutine 泄漏**：高并发下连接池泄漏导致服务 OOM，
  使用 pprof 定位后引入 derived context 自动释放 goroutine，
  泄漏率降为 0，72h 压测稳定
```

## 模板规则

1. **项目标题行**：`## {project_name}`，二级标题
2. **项目简介行**：`> {project_brief} | {role}`，引用块格式，project_brief 和 role 取该项目最新记录的值
3. **每条记录一个要点**：
   - 加粗 task 作为标题：`**{task}**`
   - problem → solution → result 一句话串联，用逗号分隔
   - 有 metrics 则融入 result 部分，用具体数字；没有则不硬凑
4. **排序**：同一项目下按时间倒序，最新的在最上面
5. **新增记录**：追加到已有项目标题下的最上方（因为时间倒序）

## YAML 到简历条目的转换逻辑

1. 读取 YAML 记录的 `task`、`problem`、`solution`、`result`、`metrics`
2. 将 metrics 融入 result 描述（如 "goroutine_leak=0" → "泄漏率降为 0"）
3. 组装：`- **{task}**：{problem}，{solution}，{result}`
4. 检查简历文件中是否已有该项目的标题行：
   - 已有：在该项目的要点列表最上方插入新条目
   - 没有：在简历文件末尾新增项目标题行 + 要点

## 语言

当前仅支持中文简历输出。
