# YAML 开发记录字段规范

## 完整示例

```yaml
- id: 20260704-001
  date: 2026-07-04

  project: A2A-Gateway
  project_brief: 基于 Go 的 Agent-to-Agent 通信网关中间件

  task: 修复 WebSocket goroutine 泄漏

  tech:
    - Go
    - WebSocket
    - Context
    - pprof

  problem: 高并发下 WebSocket 连接池泄漏，导致服务 OOM。

  solution: 使用 pprof 定位问题，为每个连接引入 derived context，实现连接关闭时 goroutine 自动释放。

  result: goroutine 泄漏率降为 0，72 小时压力测试无 OOM。

  metrics:
    - goroutine_leak=0
    - stress_test=72h

  role:
    - 后端开发
```

## 字段说明

| 字段 | 必填 | 来源 | 说明 |
|------|------|------|------|
| `id` | 是 | 自动生成 | 格式 `YYYYMMDD-NNN`，日期 + 当日序号 |
| `date` | 是 | 自动生成 | 当天日期 `YYYY-MM-DD` |
| `project` | 是 | 推断/用户指定 | 项目名，从 git 仓库名推断或用户参数指定 |
| `project_brief` | 首次必填 | 对话上下文 | 项目一句话简介，同项目已有记录则继承 |
| `task` | 是 | 推断 | 本次做了什么，简短描述 |
| `tech` | 是 | git diff + 上下文 | 涉及的技术栈列表 |
| `problem` | 是 | 对话上下文 | 遇到了什么问题 |
| `solution` | 是 | 对话上下文 | 怎么定位和解决的 |
| `result` | 是 | 对话上下文 | 最终效果 |
| `metrics` | 否 | git diff + 上下文 | 可量化的结果指标，格式 `key=value` |
| `role` | 是 | 推断/用户补充 | 在项目中的角色 |

## 同项目 project_brief 继承规则

当日志文件中已存在同 `project` 的记录时，`project_brief` 自动继承最近一条的值，不需要重复填写。仅当用户明确要求更新简介时才覆盖。

## id 生成规则

1. 取当天日期作为前缀 `YYYYMMDD`
2. 查找日志文件中同日期已有的最大序号
3. 序号 +1，不足三位左补零
4. 示例：当天已有 `20260704-001`、`20260704-002`，下一条为 `20260704-003`
